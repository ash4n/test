TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e
FINALPACKAGE = 1
STRIP = 0
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = entry2_type0x0f

entry2_type0x0f_FILES = main.c driver.c ipc.c krw.c memory.c pac.c traps.c dlsym.c
entry2_type0x0f_CFLAGS = -fobjc-arc -Wno-unused-variable -Wno-unused-function
entry2_type0x0f_FRAMEWORKS = CoreFoundation IOKit Security
entry2_type0x0f_INSTALL_PATH = /usr/local/lib

include $(THEOS_MAKE_PATH)/library.mk
