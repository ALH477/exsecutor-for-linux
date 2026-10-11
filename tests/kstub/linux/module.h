/* tests/kstub/linux/module.h — userspace stub of <linux/module.h>.
 * GPL-2.0-only. Only the macros src/mod.c uses. module_init/module_exit
 * become plain function calls the gate never runs; MODULE_* become no-ops. */
#ifndef KSTUB_LINUX_MODULE_H
#define KSTUB_LINUX_MODULE_H

#define MODULE_LICENSE(x)    extern int __kstub_license
#define MODULE_AUTHOR(x)     extern int __kstub_author
#define MODULE_DESCRIPTION(x) extern int __kstub_description
#define MODULE_VERSION(x)    extern int __kstub_version

#define module_init(fn) \
	static int (*__kstub_init_##fn)(void) __attribute__((used)) = fn
#define module_exit(fn) \
	static void (*__kstub_exit_##fn)(void) __attribute__((used)) = fn

#endif
