// SPDX-License-Identifier: GPL-2.0-only
/*
 * The one symbol an Exsecutor --emitte c library-mode unit imports.
 * Written here in kernel C. Do not take this from Exsecutor's runtime
 * (GPL-3.0-or-later). Exception A covers emitted C; it does not cover
 * linking the compiler's own abort helper.
 *
 * ADR 0020 (Exsecutor docs/decisions/0020-trap-abi-returns-verdict.md):
 * the trap ABI returns a verdict. exsrt_abortus(kind) -> int. A trap is a
 * runtime event; this shim is the kernel host, and the kernel host fails
 * closed by returning -EPERM. The emitted function returns 0 (admit) after
 * the call; the LSM's own logic sees the 0 and must override it to deny.
 * 0 from exsrt_abortus itself would be fail-open; this shim never returns 0.
 */

#include <linux/kernel.h>
#include <linux/errno.h>
#include <linux/export.h>

#include "exsrt_abortus.h"

int exsrt_abortus(unsigned kind)
{
	pr_err("exsecutor_enforce: trap kind=%u; returning -EPERM (ADR 0020)\n",
	       kind);
	return -EPERM;
}
EXPORT_SYMBOL_GPL(exsrt_abortus);
