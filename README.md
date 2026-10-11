# Exsecutor-for-Linux

Out-of-tree kernel module **prep**, not a `linux.git` tree.

Linux is Linus Torvalds' mark. This repo is a descriptive project label
(`Exsecutor-for-Linux`). It is not a product named Linux.

## What this is

A GPL-2.0-only `obj-m` wrapper, a hand-written `exsrt_abortus` shim, and
**one Exsecutor-emitted unit linked in**: `src/custos.c` is the DCF datagram
gate (`examples/custos/` in the Exsecutor checkout) over the entry-23
codec, emitted by `exsc --emitte c` and relicensed GPL-2.0-only under
Exception A. K2 item 1 (float/SIMD prologue gate) is done upstream, so the
unit compiles under `-mno-sse -mgeneral-regs-only`.

It is **not**:

- a clone or fork of `torvalds/linux` (do not drop that on this laptop)
- `ALH477/linux-ArchibaldOS` (CachyOS PKGBUILDs, no Exsecutor)
- an LSM yet (`bprm_check_security` is Phase K3, after K2 item 3)
- safe to call into: `exsrt_abortus` still `BUG()`s on a trap, because the
  trap ABI is `_Noreturn` and an LSM must fail closed by *returning*
  `-EPERM`. That is K2 item 3, and it is why `mod.c` links `custos.o`
  without calling it.

## The Kbuild-shape gate (no kernel headers needed)

```
tests/kbuild-shape.sh [EXSECUTOR_CHECKOUT]
```

Proves, without a Kbuild tree: the checked-in `src/custos.c` is
byte-identical to what the sibling Exsecutor checkout's `exsc` re-emits
(a stale or hand-edited unit is refused); every object in
`exsecutor_enforce-y` compiles under the kernel flag set
(`-mcmodel=kernel -mno-sse -mgeneral-regs-only -mno-red-zone
-fno-stack-protector -ffreestanding -fno-builtin -fno-pie`) with the
`<linux/*>` headers macro-stubbed under `tests/kstub/`; `custos.o`'s import
surface is exactly `{exsrt_abortus}`; every object's largest frame is under
4 KB (`-fstack-usage`); and `exs_admitte` answers the three verdict anchors
(0 3 6) through the shim. What it does **not** prove: objtool acceptance, a
real Kbuild link, or a returning trap ABI.

## Which of the two docs to believe

| File | Where | Status |
|---|---|---|
| `exsecutor-kernel-enforcement.md` (326 lines) | Oligarchy repo root, **untracked** | Stale draft. Finding 5 still says fix the licence before any kernel code. |
| `docs/exsecutor-kernel-roadmap.md` (604 lines) | Oligarchy `main` (PR #51) | **Live.** Exception A covers `--emitte c`. Phase 0.5/K2 are the gate. Policy compiler before ring 0. |

Details: `docs/FROM-THE-TWO.md`.

## Licence

Kernel-side files: **GPL-2.0-only** (`SPDX-License-Identifier: GPL-2.0-only`).
`MODULE_LICENSE("GPL")` so `EXPORT_SYMBOL_GPL` stays reachable.

Exsecutor itself stays GPL-3.0-or-later. Do not relicense it. Exception A
makes emitted C yours to put under GPL-2.0-only. The one imported symbol is
written here, in kernel C: `src/exsrt_abortus.c`.

Inbound: `DCO.md`. Every commit must have `Signed-off-by:`.

## Build (when you have headers)

NixOS often has no `/lib/modules/$(uname -r)/build`. Do not `nix-build` a
kernel on the Framework 16 while Steam is the workload.

```
make KDIR=/path/to/linux-headers
```

Expected when KDIR is real: `src/exsecutor_enforce.ko`.
Expected when KDIR is missing: make fails looking for `KDIR`. That is not a
module bug.

## Phase map (from the live roadmap)

- **K0** hardened host kernel — Oligarchy, not this repo
- **K1** policy compiler (IPE/Landlock/seccomp) — Exsecutor + Oligarchy userspace
- **K2** language: gate the float prologue (DONE upstream, `b0aeca3`), frame cap, returning trap, `externus`, kernel atoms — **Exsecutor**
- **K3** this tree grows an emitted unit (DONE: `src/custos.c`, linked) + log-only LSM (BLOCKED on K2 item 3: the trap ABI must return a verdict)
- **K5** agent isolation is `modules/oligarchy-plugins/` tier 2, already shipped

Do not skip K2 by pasting `prologue.c.in` into Kbuild.
