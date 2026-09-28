// SPDX-License-Identifier: GPL-2.0-only
/*
 * Trivial out-of-tree stub. Log-only. Not an LSM.
 *
 * Phase K3 (Oligarchy docs/exsecutor-kernel-roadmap.md) is: obj-m wrapper,
 * then a log-only LSM on bprm_check_security, after K2 makes emitted C
 * kernel-eligible. This file is the wrapper. It does not call Exsecutor.
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Asher <leroy@demod.ltd>");
MODULE_DESCRIPTION("Exsecutor enforcement stub; evaluator not linked (Phase K2 open)");
MODULE_VERSION("0.0.0");

static int __init exsecutor_enforce_init(void)
{
	pr_info("exsecutor_enforce: stub loaded; no evaluator (Phase K2)\n");
	return 0;
}

static void __exit exsecutor_enforce_exit(void)
{
	pr_info("exsecutor_enforce: unloaded\n");
}

module_init(exsecutor_enforce_init);
module_exit(exsecutor_enforce_exit);
