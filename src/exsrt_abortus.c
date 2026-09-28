// SPDX-License-Identifier: GPL-2.0-only
/*
 * The one symbol an Exsecutor --emitte c library-mode unit imports.
 * Written here in kernel C. Do not take this from Exsecutor's runtime
 * (GPL-3.0-or-later). Exception A covers emitted C; it does not cover
 * linking the compiler's own abort helper.
 *
 * Exsecutor's host shims are _Noreturn void exsrt_abortus(unsigned).
 * An LSM that must fail closed has to return -EPERM. That is Phase K2
 * item 3 (trap ABI). Until then a trap panics: fail closed the only
 * way a _Noreturn callee allows.
 */

#include <linux/kernel.h>
#include <linux/bug.h>
#include <linux/export.h>

#include "exsrt_abortus.h"

void exsrt_abortus(unsigned kind)
{
	pr_err("exsecutor_enforce: trap kind=%u; Phase K2 has no returning ABI\n",
	       kind);
	BUG();
}
EXPORT_SYMBOL_GPL(exsrt_abortus);
