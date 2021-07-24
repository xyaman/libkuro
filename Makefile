export ARCHS = arm64 arm64e
export SYSROOT = $(THEOS)/sdks/iPhoneOS13.0.sdk
export PREFIX=$(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/
export TARGET = iphone:clang:14.5:13.0

LIBRARY_NAME = libKuro
$(LIBRARY_NAME)_FILES = $(wildcard *.m)
$(LIBRARY_NAME)_CFLAGS = -fobjc-arc
$(LIBRARY_NAME)_FRAMEWORKS = UIKit CoreGraphics CoreImage

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/library.mk

stage::
	mkdir -p $(THEOS_STAGING_DIR)/usr/include/libKuro
	$(ECHO_NOTHING)rsync -a ./public/* $(THEOS_STAGING_DIR)/usr/include/Kuro $(FW_RSYNC_EXCLUDES)$(ECHO_END)
	mkdir -p $(THEOS)/include/Kuro
	cp -r ./public/* $(THEOS)/include/Kuro
	cp $(THEOS_STAGING_DIR)/usr/lib/libKuro.dylib $(THEOS)/lib/libKuro.dylib