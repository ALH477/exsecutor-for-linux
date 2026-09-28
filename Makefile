# SPDX-License-Identifier: GPL-2.0-only
KDIR ?= /lib/modules/$(shell uname -r)/build
M := $(CURDIR)/src

ifeq ($(wildcard $(KDIR)/Makefile),)
$(warning KDIR=$(KDIR) has no Makefile — pass KDIR=; do not nix-build a kernel on the gaming laptop)
endif

all:
	$(MAKE) -C $(KDIR) M=$(M) modules

clean:
	$(MAKE) -C $(KDIR) M=$(M) clean

.PHONY: all clean
