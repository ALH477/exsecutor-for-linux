# Look: the two kernel-enforcement documents

Read 2026-09-28 against:

- `/home/asher/Documents/oligarchy2/Oligarchy/exsecutor-kernel-enforcement.md` (untracked, 326 lines)
- Oligarchy `origin/main` `docs/exsecutor-kernel-roadmap.md` (604 lines, PR #51 / merge `fe53c7c`)

Same title. The draft is the hypothesis; the roadmap is the corrected assessment.

## Summary items that changed

| # | Draft (`enforcement.md`) | Live roadmap |
|---|---|---|
| 3 | SEV-SNP optional | **Measured absent** on Framework 16 (no `sev`/`sev_es`/`sev_snp`) |
| 4 | C backend inherits Kbuild hardening; stop | Obstacles are **in the language**. Six Phase 0.5/K2 items. Import surface `{exsrt_abortus, memcpy, memset}` |
| 5 | “Licensing conflict must be resolved before any kernel code” (`:27-28`) | Conflict **does not arise** on `--emitte c`. Exception A. Write `exsrt_abortus` in kernel C. Adopt a **DCO** (this repo has `DCO.md`) |
| 6 | Seal generation with dm-verity + UKI | Same, plus: captive-portal pipeline already builds the verify half — reuse it |
| 7 | (missing) | Policy compiler **before** ring 0. This `.ko` is last, not first |

Draft has no “Measured starting point” table (running `7.0.10-zen1`: no IPE, no kCFI Clang, `RANDSTRUCT_NONE`, LSM `capability,landlock,yama,bpf`).

## Isolation — keep (both)

Literal x86 CPL 1/2 does not isolate (paging U/S is binary; long mode dropped segment limits). Mapping: host enforcer in **VMX-root ring 0**; agent in a **KVM microVM** (non-root). Agent never issues a host syscall.

Do not fork Linux to get rings 1/2. This repo is an out-of-tree module, not that.

## Language blockers still in Exsecutor (roadmap is right)

Cited from `/home/asher/Documents/EXSECUTOR` at look time:

- `compiler/x86_64/backend_c/prologue.c.in:7` includes `<float.h>`; `:123-128` `vector_size` up to 64 bytes. Every `--emitte c` TU. Kbuild `-mno-sse` collides.
- `examples/metronomus/exemplum.c:27` `_Noreturn void exsrt_abortus`. An LSM must **return** `-EPERM`. This repo’s shim `BUG()`s and says so.
- `tests/conformance/entry13_nonatomic_refero_externus.exsc:23-25` is the only `externus`, and it is a **rejection** (`EXS-E0520`).

Until those six K2 measurements pass, `src/` stays a C stub. No emitted files.

## Order — keep (roadmap item 7)

First valuable artifact is userspace: one declaration → IPE / Landlock / seccomp. Consumers already exist in Oligarchy plugins. Ring-0 is K3+.

## Hygiene

The untracked draft at Oligarchy repo root will be the first file an agent `find`s. Do not `git add` it into Oligarchy. Delete or gitignore it there so this look is not done again on the wrong text.

## Not legal advice

Roadmap §G: out-of-tree + `EXPORT_SYMBOL_GPL` is treated as derivative. This tree assumes GPL-2.0-only.
