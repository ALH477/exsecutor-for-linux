/* tests/kstub/linux/bug.h — userspace stub of <linux/bug.h>.
 * GPL-2.0-only. BUG() becomes __builtin_trap(), which is ud2 on x86-64. */
#ifndef KSTUB_LINUX_BUG_H
#define KSTUB_LINUX_BUG_H
#define BUG() __builtin_trap()
#endif
