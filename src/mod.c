// SPDX-License-Identifier: GPL-2.0-only
/*
 * Out-of-tree stub. Log-only. Not an LSM.
 *
 * Phase K3 (Oligarchy docs/exsecutor-kernel-roadmap.md) is: obj-m wrapper,
 * then a log-only LSM on bprm_check_security, after K2 makes emitted C
 * kernel-eligible. This file is the wrapper. custos.o IS linked (Kbuild) and
 * its exs_admitte is callable, but nothing here calls it yet: there is no
 * hook, and roadmap K2 item 3 (a trap ABI that can return -EPERM) is open.
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Asher <leroy@demod.ltd>");
MODULE_DESCRIPTION("Exsecutor enforcement stub; evaluator linked, no hook (K2.3 open)");
MODULE_VERSION("0.1.0");

static int __init exsecutor_enforce_init(void)
{
	pr_info("exsecutor_enforce: stub loaded; custos.o linked, no hook (K2.3 open)\n");
	return 0;
}

static void __exit exsecutor_enforce_exit(void)
{
	pr_info("exsecutor_enforce: unloaded\n");
}

module_init(exsecutor_enforce_init);
module_exit(exsecutor_enforce_exit);
