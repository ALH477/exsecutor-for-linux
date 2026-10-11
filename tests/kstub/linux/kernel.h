/* tests/kstub/linux/kernel.h — userspace stub of <linux/kernel.h>.
 * GPL-2.0-only. Only what src/ uses: pr_info/pr_err.
 * Freestanding: no libc include, so the object compiles under the kernel
 * flag set this gate asserts. */
#ifndef KSTUB_LINUX_KERNEL_H
#define KSTUB_LINUX_KERNEL_H

typedef unsigned int __kstub_u32;

static inline void __kstub_pr(const char *lvl, const char *fmt, ...)
{
	(void)lvl; (void)fmt;
}
#define pr_info(fmt, ...) __kstub_pr("info", fmt, ##__VA_ARGS__)
#define pr_err(fmt, ...)  __kstub_pr("err",  fmt, ##__VA_ARGS__)

#endif
