TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e
FINALPACKAGE = 1
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = corunademo
corunademo_FILES = coruna_demo.m
corunademo_CFLAGS = -fobjc-arc
corunademo_LDFLAGS = -lobjc -framework CoreFoundation
corunademo_INSTALL_PATH = /usr/local/lib

include $(THEOS_MAKE_PATH)/library.mk