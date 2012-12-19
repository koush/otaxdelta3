LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE    := unzip
LOCAL_SRC_FILES := ../unzip/unzip.c ../unzip/ioapi.c ../unzip/miniunz.c
LOCAL_CFLAGS := -DIOAPI_NO_64
LOCAL_LDLIBS := -lz
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE    := zip
LOCAL_SRC_FILES := ../unzip/zip.c ../unzip/ioapi.c ../unzip/minizip.c
LOCAL_CFLAGS := -DIOAPI_NO_64 -DNOCRYPT
LOCAL_LDLIBS := -lz
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE    := xdelta3
LOCAL_SRC_FILES := ../xdelta3/xdelta3.c
LOCAL_CFLAGS := -DGENERIC_ENCODE_TABLES=1 \
		-DREGRESSION_TEST=1 \
		-DSECONDARY_DJW=1 \
		-DSECONDARY_FGK=1 \
		-DXD3_DEBUG=1 \
		-DXD3_MAIN=1 \
		-DXD3_POSIX=1 \
		-DXD3_USE_LARGEFILE64=1

LOCAL_LDLIBS := -lz
include $(BUILD_EXECUTABLE)
