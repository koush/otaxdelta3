LOCAL_PATH := $(call my-dir)

zlib_files := \
	adler32.c \
	compress.c \
	crc32.c \
	deflate.c \
	gzclose.c \
	gzlib.c \
	gzread.c \
	gzwrite.c \
	infback.c \
	inflate.c \
	inftrees.c \
	inffast.c \
	slhash.c \
	trees.c \
	uncompr.c \
	zutil.c

zlib_arm_files :=
zlib_arm_flags :=

include $(CLEAR_VARS)

LOCAL_ARM_MODE := arm
LOCAL_MODULE := libz
LOCAL_CFLAGS += -O3 -DUSE_MMAP $(zlib_arm_flags)
LOCAL_SRC_FILES := $(foreach __file,$(zlib_files) $(zlib_arm_files), ../zlib/$(__file))
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := unzip
LOCAL_SRC_FILES := ../unzip/unzip.c ../unzip/ioapi.c ../unzip/miniunz.c
LOCAL_CFLAGS := -DIOAPI_NO_64
LOCAL_STATIC_LIBRARIES := z
LOCAL_LDFLAGS := -static
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE    := zip
LOCAL_SRC_FILES := ../unzip/zip.c ../unzip/ioapi.c ../unzip/minizip.c
LOCAL_CFLAGS := -DIOAPI_NO_64 -DNOCRYPT
LOCAL_STATIC_LIBRARIES := z
LOCAL_LDFLAGS := -static
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
