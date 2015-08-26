LOCAL_PATH := $(call my-dir)

OPENCV_SDK_DIR := ./sdk/opencv-sdk
include $(CLEAR_VARS)

include $(OPENCV_SDK_DIR)/native/jni/OpenCV.mk

LOCAL_MODULE    := libunityopencv
LOCAL_SRC_FILES := unityopencv.cpp
LOCAL_LDLIBS    += -ldl -llog
OPENCV_LIB_TYPE := SHARED
LOCAL_SHARED_LIBRARIES += opencv_java

include $(BUILD_SHARED_LIBRARY)

$(call import-module,android/native_app_glue)
