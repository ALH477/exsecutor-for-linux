/* SPDX-License-Identifier: GPL-2.0-only */
#ifndef EXSRT_ABORTUS_H
#define EXSRT_ABORTUS_H

/* ADR 0020: the trap ABI returns a verdict (int). The kernel host returns
 * -EPERM (fail closed). The userspace shim never returns. */
int exsrt_abortus(unsigned kind);

#endif
