# Copyright (C) 2023 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include device/qcom/common/qcom_defs.mk

# Use the configs for TARGET_BOARD_PLATFORM unless otherwise specified
ifeq ($(TARGET_BOARD_PLATFORM)$(TARGET_BOARD_SUFFIX),bengal_515)
    TARGET_PERF_DIR := bengal_515
else
    TARGET_PERF_DIR := $(TARGET_BOARD_PLATFORM)
endif

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,device/qcom/common/vendor/perf/configs/common,$(TARGET_COPY_OUT_VENDOR)/etc) \
    $(call find-copy-subdir-files,*,device/qcom/common/vendor/perf/configs/$(TARGET_PERF_DIR),$(TARGET_COPY_OUT_VENDOR)/etc)

# Disable IOP HAL for select platforms.
ifneq ($(filter msm8937 msm8953 msm8998 qcs605 sdm660 sdm710,$(TARGET_BOARD_PLATFORM)),)
PRODUCT_COPY_FILES += \
    device/qcom/common/vendor/perf/vendor.qti.hardware.iop@2.0-service-disable.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/vendor.qti.hardware.iop@2.0-service-disable.rc
endif

# Disable the poweropt service for <5.4 platforms.
ifneq ($(filter-out $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
PRODUCT_COPY_FILES += \
    device/qcom/common/vendor/perf/poweropt-service-disable.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/poweropt-service-disable.rc
endif

# Packages
PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0.vendor \
    android.hardware.thermal-V1-ndk.vendor \
    libavservices_minijail.vendor \
    libpsi.vendor \
    libtflite \
    vendor.qti.hardware.servicetracker@1.2.vendor

# Only copy task_profiles.json for 5.4 targets.
ifneq ($(filter $(UM_5_4_FAMILY),$(TARGET_BOARD_PLATFORM)),)
PRODUCT_COPY_FILES += \
    system/core/libprocessgroup/profiles/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json
endif

# Properties
PRODUCT_VENDOR_PROPERTIES += \
    persist.sys.perf.boost.enable=1 \
    ro.vendor.perf-hal.ver=3.0 \
    ro.vendor.extension_library=libqti-perfd-client.so \
    ro.vendor.perf.scroll_opt=true \
    ro.vendor.qspm.enable=true \
    vendor.power.pasr.enabled=false \
    vendor.pasr.activemode.enabled=false \
    vendor.perf.framepacing.enable=1

ifneq ($(filter $(UM_4_19_FAMILY) $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.beluga.p=0x3 \
    ro.vendor.beluga.c=0x4800 \
    ro.vendor.beluga.s=0x900 \
    ro.vendor.beluga.t=0x240
endif

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/qcom/common/vendor/perf/perf-vendor.mk)