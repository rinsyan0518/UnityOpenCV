APP_PROJECT_PATH := $(NDK_PROJECT_PATH)

APP_ABI := armeabi-v7a x86
APP_STL := gnustl_static
APP_CPPFLAGS := -frtti -fexceptions
APP_PLATFORM := android-9
APP_BUILD_SCRIPT := $(NDK_PROJECT_PATH)/Android.mk

