LOCAL_PATH := $(call my-dir)

########################
# Binaries
########################

# Global toggle for the WIP zygote injection features
ENABLE_INJECT := 0

ifdef B_MAGISK

include $(CLEAR_VARS)
LOCAL_MODULE := magisk
LOCAL_STATIC_LIBRARIES := libnanopb libsystemproperties libutils
LOCAL_C_INCLUDES := jni/include

LOCAL_SRC_FILES := \
    core/applets.cpp \
    core/magisk.cpp \
    core/daemon.cpp \
    core/bootstages.cpp \
    core/socket.cpp \
    core/db.cpp \
    core/scripting.cpp \
    core/restorecon.cpp \
    core/module.cpp \
    jokerhide/jokerhide.cpp \
    jokerhide/hide_utils.cpp \
    jokerhide/hide_policy.cpp \
    joyoeprop/persist_properties.cpp \
    joyoeprop/joyoeprop.cpp \
    su/su.cpp \
    su/connect.cpp \
    su/pts.cpp \
    su/su_daemon.cpp

LOCAL_LDLIBS := -llog
LOCAL_CPPFLAGS := -DENABLE_INJECT=$(ENABLE_INJECT)

ifeq ($(ENABLE_INJECT),1)
LOCAL_STATIC_LIBRARIES += libxhook
LOCAL_SRC_FILES += \
    inject/entry.cpp \
    inject/utils.cpp \
    inject/hook.cpp
else
LOCAL_SRC_FILES += jokerhide/proc_monitor.cpp
endif

include $(BUILD_EXECUTABLE)

endif

include $(CLEAR_VARS)

ifdef B_INIT

LOCAL_MODULE := jokerinit
LOCAL_STATIC_LIBRARIES := libsepol libxz libutils
LOCAL_C_INCLUDES := jni/include out

LOCAL_SRC_FILES := \
    init/init.cpp \
    init/mount.cpp \
    init/rootdir.cpp \
    init/getinfo.cpp \
    init/twostage.cpp \
    init/raw_data.cpp \
    core/socket.cpp \
    jokerpolicy/sepolicy.cpp \
    jokerpolicy/jokerpolicy.cpp \
    jokerpolicy/rules.cpp \
    jokerpolicy/policydb.cpp \
    jokerpolicy/statement.cpp \
    jokerboot/pattern.cpp

LOCAL_LDFLAGS := -static
include $(BUILD_EXECUTABLE)

endif

ifdef B_BOOT

include $(CLEAR_VARS)
LOCAL_MODULE := jokerboot
LOCAL_STATIC_LIBRARIES := libmincrypt liblzma liblz4 libbz2 libfdt libutils libz
LOCAL_C_INCLUDES := jni/include

LOCAL_SRC_FILES := \
    jokerboot/main.cpp \
    jokerboot/bootimg.cpp \
    jokerboot/hexpatch.cpp \
    jokerboot/compress.cpp \
    jokerboot/format.cpp \
    jokerboot/dtb.cpp \
    jokerboot/ramdisk.cpp \
    jokerboot/pattern.cpp \
    utils/cpio.cpp

LOCAL_LDFLAGS := -static
include $(BUILD_EXECUTABLE)

endif

ifdef B_POLICY

include $(CLEAR_VARS)
LOCAL_MODULE := jokerpolicy
LOCAL_STATIC_LIBRARIES := libsepol libutils
LOCAL_C_INCLUDES := jni/include

LOCAL_SRC_FILES := \
    core/applet_stub.cpp \
    jokerpolicy/sepolicy.cpp \
    jokerpolicy/jokerpolicy.cpp \
    jokerpolicy/rules.cpp \
    jokerpolicy/policydb.cpp \
    jokerpolicy/statement.cpp

LOCAL_CFLAGS := -DAPPLET_STUB_MAIN=jokerpolicy_main
LOCAL_LDFLAGS := -static
include $(BUILD_EXECUTABLE)

endif

ifdef B_PROP

include $(CLEAR_VARS)
LOCAL_MODULE := joyoeprop
LOCAL_STATIC_LIBRARIES := libnanopb libsystemproperties libutils
LOCAL_C_INCLUDES := jni/include

LOCAL_SRC_FILES := \
    core/applet_stub.cpp \
    joyoeprop/persist_properties.cpp \
    joyoeprop/joyoeprop.cpp \

LOCAL_CFLAGS := -DAPPLET_STUB_MAIN=joyoeprop_main
LOCAL_LDFLAGS := -static
include $(BUILD_EXECUTABLE)

endif

ifdef B_TEST
ifneq (,$(wildcard jni/test.cpp))

include $(CLEAR_VARS)
LOCAL_MODULE := test
LOCAL_STATIC_LIBRARIES := libutils
LOCAL_C_INCLUDES := jni/include
LOCAL_SRC_FILES := test.cpp
include $(BUILD_EXECUTABLE)

endif
endif

ifdef B_BB

include jni/external/busybox/Android.mk

endif

########################
# Libraries
########################
include jni/utils/Android.mk
include jni/external/Android.mk
