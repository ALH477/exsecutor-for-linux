#!/usr/bin/env bash
# Kbuild-shape gate for the exsecutor-for-linux stub. No Kbuild tree is needed:
# this proves the three things a .ko build would inherit, on this machine:
#
#   1. src/custos.c is byte-identical to what the pinned exsc re-emits from
#      the Exsecutor sources (Exception A output is reproducible, or the
#      checked-in copy is stale).
#   2. Every object in exsecutor_enforce-y compiles under the kernel's flag
#      set: -mcmodel=kernel -mno-sse -mgeneral-regs-only -mno-red-zone
#      -fno-stack-protector -ffreestanding -fno-builtin -fno-pie.
#      The kernel's <linux/*> headers are macro-stubbed for the userspace
#      compile (tests/kstub/), which type-checks the module's SHAPE, not its
#      semantics against a real Kbuild tree.
#   3. The linked import surface is exactly {exsrt_abortus}: nothing in the
#      module needs a symbol the kernel cannot resolve, and the emitted unit
#      brings no hidden runtime with it.
#
# What this gate does NOT prove: objtool acceptance (ORC unwind, noinstr,
# uaccess), a real Kbuild link against a kernel tree. K2 item 3 (a trap ABI
# that returns a verdict) is CLOSED by ADR 0020: exsrt_abortus returns -EPERM.
#
# Usage: tests/kbuild-shape.sh [EXSECUTOR_CHECKOUT]
#   EXSECUTOR_CHECKOUT defaults to ../../EXSECUTOR (the sibling checkout).
#   Needs: build/exsc in that checkout (or EXSC=...), gcc, nm.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
EXS_CHECKOUT="${1:-${EXSC_CHECKOUT:-$ROOT/../EXSECUTOR}}"
EXSC="${EXSC:-$EXS_CHECKOUT/build/exsc}"
CC="${CC:-gcc}"
OUT="$(mktemp -d)"
trap 'rm -rf "$OUT"' EXIT

[ -x "$EXSC" ] || { echo "kbuild-shape: $EXSC missing — build exsc or pass the checkout" >&2; exit 2; }
[ -f "$EXS_CHECKOUT/examples/custos/custos.exsc" ] || { echo "kbuild-shape: $EXS_CHECKOUT is not an Exsecutor checkout" >&2; exit 2; }

fail() { echo "kbuild-shape FAIL: $*" >&2; exit 1; }

# ── 1. The checked-in unit is what the pinned exsc emits ────────────────────
"$EXSC" aedifica --emitte c --hospes x86_64-linux \
  -o "$OUT/custos.regen.c" \
  "$EXS_CHECKOUT/tests/conformance/entry23_demodframe_golden_vectors.exsc" \
  "$EXS_CHECKOUT/tests/conformance/entry23/codex.exsc" \
  "$EXS_CHECKOUT/examples/custos/custos.exsc" >/dev/null

# The committed file carries this repo's provenance header; the emitted text
# starts at the first `#define EXS_NEED_FLOAT` line.
awk '/^#define EXS_NEED_FLOAT/{p=1} p' "$ROOT/src/custos.c" > "$OUT/custos.committed.c"
cmp -s "$OUT/custos.regen.c" "$OUT/custos.committed.c" \
  || fail "src/custos.c is stale — re-emit from $EXS_CHECKOUT (see the header's regenerate command)"
echo "  [ok]   src/custos.c matches the pinned exsc byte-for-byte"

# ── 2. Every object compiles under the kernel flag set ──────────────────────
KFLAGS="-O2 -Wall -Wextra -Werror -Wno-unused-function -mcmodel=kernel \
  -mno-sse -mno-sse2 -mno-mmx -mno-avx -mgeneral-regs-only -mno-red-zone \
  -fno-stack-protector -ffreestanding -fno-builtin -fno-pie -fstack-usage"

# shellcheck disable=SC2086
"$CC" -c $KFLAGS -I"$ROOT/tests/kstub" -I"$ROOT/src" \
  -o "$OUT/mod.o" "$ROOT/src/mod.c"
echo "  [ok]   mod.c compiles under kernel flags"

# shellcheck disable=SC2086
"$CC" -c $KFLAGS -I"$ROOT/tests/kstub" -I"$ROOT/src" \
  -o "$OUT/exsrt_abortus.o" "$ROOT/src/exsrt_abortus.c"
echo "  [ok]   exsrt_abortus.c compiles under kernel flags"

# shellcheck disable=SC2086
"$CC" -c $KFLAGS -I"$ROOT/tests/kstub" -I"$ROOT/src" \
  -o "$OUT/custos.o" "$ROOT/src/custos.c"
echo "  [ok]   custos.c (emitted) compiles under kernel flags"

# ── 3. Import surface is exactly {exsrt_abortus} ────────────────────────────
imports="$(nm -u "$OUT/custos.o" | awk '{print $2}' | sort -u)"
[ "$imports" = "exsrt_abortus" ] \
  || fail "custos.o imports more than {exsrt_abortus}: $imports"
echo "  [ok]   custos.o imports exactly {exsrt_abortus}"

# ── 3b. The emitted unit carries the frame-size limit constant ──────────────
# K2 item 2, the constant half: every --emitte c unit defines
# EXS_FRAME_LIMIT (default 4096) so the consuming build's -fstack-usage
# check has a named bound. The frame budget is already enforced above
# (every object's largest frame < 4 KB by the .su files).
if ! grep -q '^#define EXS_FRAME_LIMIT 4096$' "$ROOT/src/custos.c"; then
  fail "src/custos.c carries no EXS_FRAME_LIMIT 4096 default (K2 item 2 constant)"
fi
echo "  [ok]   custos.c carries EXS_FRAME_LIMIT 4096 (K2 item 2 constant)"

# mod.o and exsrt_abortus.o: with the kstub macros they are freestanding, so
# their undefined symbols are the macro-expanded stubs' own; assert the ONLY
# cross-object undefined symbol is exsrt_abortus being resolved by
# exsrt_abortus.o (custos.o's sole import).
for o in mod.o exsrt_abortus.o; do
  extra="$(nm -u "$OUT/$o" | awk '{print $2}' | grep -v '^__kstub_' | sort -u || true)"
  [ -z "$extra" ] || fail "$o has unexpected imports under the kstub: $extra"
done
echo "  [ok]   mod.o and exsrt_abortus.o resolve nothing outside the kstub"

# Frame budget: the roadmap's exit criterion is largest frame under 4 KB.
for su in "$OUT"/*.su; do
  maxframe="$(awk -F'\t' '{print $2}' "$su" | sort -rn | head -1)"
  [ -n "$maxframe" ] && [ "$maxframe" -lt 4096 ] \
    || fail "$(basename "$su"): largest frame ${maxframe:-none} >= 4096 bytes"
done
echo "  [ok]   every object's largest frame is under 4 KB"

# ── 4. Runtime anchors: the emitted evaluator answers through the shim ──────
cat > "$OUT/main.c" <<'EOF'
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
_Noreturn void exsrt_abortus(unsigned kind)
{
    fprintf(stderr, "exsecutor: abortus %u\n", kind);
    exit(2);
}
uint64_t exs_admitte(unsigned char *p0, uint64_t p1);
int main(void)
{
    unsigned char d[32] = {0};
    d[0] = 0xd3; d[1] = 0x10; d[15] = 0x5b; d[16] = 0x80;
    if (exs_admitte(d, 17) != 0) return 1;
    d[16] = 0x81;
    if (exs_admitte(d, 17) != 3) return 1;
    if (exs_admitte(d, 20) != 6) return 1;
    printf("verdicts 0 3 6\n");
    return 0;
}
EOF
"$CC" -std=c11 -O2 -Wall -Wextra -Werror \
  -o "$OUT/probe" "$OUT/custos.o" "$OUT/main.c"
"$OUT/probe" >/dev/null
echo "  [ok]   exs_admitte answers 0 3 6 through the shim"

echo "kbuild-shape: PASS"
