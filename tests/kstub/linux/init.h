/* tests/kstub/linux/init.h — userspace stub of <linux/init.h>.
 * GPL-2.0-only. __init/__exit expand to nothing in userspace. */
#ifndef KSTUB_LINUX_INIT_H
#define KSTUB_LINUX_INIT_H
#define __init
#define __exit
#endif
