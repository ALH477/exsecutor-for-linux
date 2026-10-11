/* tests/kstub/linux/export.h — userspace stub of <linux/export.h>.
 * GPL-2.0-only. EXPORT_SYMBOL_GPL becomes a userspace-visible symbol so the
 * gate can see what the module would export. */
#ifndef KSTUB_LINUX_EXPORT_H
#define KSTUB_LINUX_EXPORT_H
#define EXPORT_SYMBOL_GPL(sym) \
	__attribute__((used)) int __kstub_export_##sym = 0
#endif
