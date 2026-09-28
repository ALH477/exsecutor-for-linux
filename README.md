# Exsecutor-for-Linux

Out-of-tree kernel module **prep**, not a `linux.git` tree.

Linux is Linus Torvalds' mark. This repo is a descriptive project label
(`Exsecutor-for-Linux`). It is not a product named Linux.

## What this is

A GPL-2.0-only `obj-m` wrapper and a hand-written `exsrt_abortus` shim, ready
for Kbuild once Exsecutor's C backend can emit a unit that survives
`-mno-sse -mgeneral-regs-only`.

It is **not**:

- a clone or fork of `torvalds/linux` (do not drop that on this laptop)
- `ALH477/linux-ArchibaldOS` (CachyOS PKGBUILDs, no Exsecutor)
- an LSM yet (`bprm_check_security` is Phase K3, after K2)
- Exsecutor-emitted C (Phase K2 is not done)

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
- **K2** language: gate the float prologue, frame cap, returning trap, `externus`, kernel atoms — **Exsecutor**
- **K3** this tree grows an emitted unit + log-only LSM
- **K5** agent isolation is `modules/oligarchy-plugins/` tier 2, already shipped

Do not skip K2 by pasting `prologue.c.in` into Kbuild.
