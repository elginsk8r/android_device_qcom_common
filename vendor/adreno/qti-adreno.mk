# Copyright (C) 2021 Paranoid Android
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

ifneq ($(filter $(LEGACY_UM_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
# Dependencies
PRODUCT_PACKAGES += \
    vendor.qti.hardware.display.mapper@2.0.vendor
endif

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml

adreno_vulkan_level :=
ifneq ($(filter $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
adreno_vulkan_level := 2022-03-01
else ifneq ($(filter $(UM_5_10_FAMILY),$(TARGET_BOARD_PLATFORM)),)
adreno_vulkan_level := 2021-03-01
else ifneq ($(filter $(LEGACY_UM_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
adreno_vulkan_level := 2020-03-01
endif

ifneq ($(adreno_vulkan_level),)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.opengles.deqp.level-$(adreno_vulkan_level).xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml

ifneq ($(filter $(UM_3_18_FAMILY) $(UM_4_4_FAMILY),$(TARGET_BOARD_PLATFORM)),)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-$(adreno_vulkan_level).xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml
endif

ifneq ($(filter 2022-03-01,$(adreno_vulkan_level)),)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml
endif
endif

# Properties
PRODUCT_VENDOR_PROPERTIES += \
    ro.hardware.egl=adreno \
    ro.hardware.vulkan=adreno \
    ro.opengles.version=196610

ifneq ($(filter $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
PRODUCT_VENDOR_PROPERTIES += \
    graphics.gpu.profiler.support=true
endif

# Get non-open-source specific aspects.
ifneq ($(filter $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
$(call inherit-product, vendor/qcom/common/vendor/adreno-s/adreno-t-vendor.mk)
else ifneq ($(filter $(UM_5_10_FAMILY),$(TARGET_BOARD_PLATFORM)),)
$(call inherit-product, vendor/qcom/common/vendor/adreno-s/adreno-s-vendor.mk)
else ifneq ($(filter $(UM_3_18_FAMILY) $(UM_4_4_FAMILY),$(TARGET_BOARD_PLATFORM)),)
$(call inherit-product, vendor/qcom/common/vendor/adreno-5xx/adreno-5xx-vendor.mk)
else
$(call inherit-product, vendor/qcom/common/vendor/adreno-r/adreno-r-vendor.mk)
endif