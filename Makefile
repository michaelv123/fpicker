.PHONY: clean fpicker-macos fpicker-linux fpicker-ios

OS ?= unknown
ARCH ?= $(shell uname -m)
CC ?= clang
FRAMEWORKS =
CFLAGS = -fPIC -ffunction-sections -fdata-sections -Wall -Os -pipe -g3
LDFLAGS = -L. -lfrida-core -ldl -lm -lresolv -pthread -latomic

ifeq ($(MAKECMDGOALS), fpicker-macos)
  OS = macos
  CC = xcrun -r clang
  FRAMEWORKS = -framework Foundation -framework CoreGraphics -framework AppKit -framework IOKit -framework Security
  LDFLAGS += -lbsm
endif

ifeq ($(MAKECMDGOALS), fpicker-linux)
  OS = linux
  LDFLAGS += -lrt -Wl,--export-dynamic -Wl,--gc-sections,-z,noexecstack
endif

ifeq ($(MAKECMDGOALS), fpicker-ios)
  OS = ios
  ARCH = arm64
  CC = xcrun -sdk iphoneos -r clang
  FRAMEWORKS = -framework Foundation -framework CoreGraphics -framework UIKit -framework IOKit -framework Security
  LDFLAGS += -arch $(ARCH)
endif

FRIDA_VERSION = 16.5.9

fpicker-macos fpicker-linux fpicker-ios:
	@echo "Building for $(OS)..."
	$(CC) $(CFLAGS) $(FRAMEWORKS) fpicker.c fp_communication.c fp_standalone_mode.c fp_afl_mode.c -o fpicker $(LDFLAGS)

clean:
	@echo "Cleaning up..."
	rm -rf fpicker fpicker.dSYM frida-devkit-* frida-core-devkit-*.tar.xz libfrida-core.a frida-core.h
