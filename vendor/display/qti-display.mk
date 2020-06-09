# Copyright (C) 2022 Paranoid Android
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

# Include display HAL makefiles.
ifneq ($(filter $(QCOM_SOONG_NAMESPACE),$(PRODUCT_SOONG_NAMESPACES)),)
    -include $(QCOM_SOONG_NAMESPACE)/display/config/display-board.mk
    -include $(QCOM_SOONG_NAMESPACE)/display/config/display-product.mk
endif

# Lights HAL
ifneq ($(filter-out $(LEGACY_UM_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
-include vendor/qcom/opensource/lights/lights-vendor-product.mk
else
PRODUCT_PACKAGES += \
    android.hardware.lights-service.qti \
    lights.qcom
endif

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml

# Packages
PRODUCT_PACKAGES += \
    android.hardware.graphics.common-V1-ndk.vendor \
    libqdutils \
    libqservice

# Properties for <5.15 targets
# These are already set on 5.15+.
ifneq ($(filter-out $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
PRODUCT_VENDOR_PROPERTIES += \
    debug.sf.auto_latch_unsignaled=0
endif

# Properties for <5.10 targets
# These are already set on 5.10+.
ifneq ($(filter-out $(LEGACY_UM_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
PRODUCT_VENDOR_PROPERTIES += \
    debug.sf.predict_hwc_composition_strategy=0 \
    debug.sf.treat_170m_as_sRGB=1
endif

# Properties for <5.4 targets
# These are already set on 5.4+
ifneq ($(filter-out $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
PRODUCT_VENDOR_PROPERTIES += \
    debug.sf.disable_client_composition_cache=1
endif

# Properties for <4.19 targets
# These are already set on 4.19+.
ifneq ($(filter-out $(UM_4_19_FAMILY) $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
PRODUCT_VENDOR_PROPERTIES += \
    debug.sf.latch_unsignaled=1
endif

# Copy feature_enabler rc only for lahaina on 5.4
ifneq ($(filter lahaina,$(TARGET_BOARD_PLATFORM)),)
PRODUCT_COPY_FILES += \
    device/qcom/common/vendor/display/5.4/feature_enabler_client.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/feature_enabler_client.rc
endif

# Gralloc usage bits
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS ?= 0
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS += | (1 << 13)
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS += | (1 << 21)
ifneq ($(filter-out $(UM_3_18_FAMILY) $(UM_4_4_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS += | (1 << 27)
endif

# Use full QTI gralloc struct for GKI 2.0 targets
ifneq ($(filter-out $(LEGACY_UM_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
    TARGET_GRALLOC_HANDLE_HAS_CUSTOM_CONTENT_MD_RESERVED_SIZE ?= true
    TARGET_GRALLOC_HANDLE_HAS_RESERVED_SIZE ?= true
endif

# REVERTME WHEN WE HAVE ANDROID 14 QPR1 BLOBS
# Disable SmoMo / Smooth Motion
PRODUCT_ODM_PROPERTIES += \
    vendor.display.use_smooth_motion=0

# Use TARGET_KERNEL_VERSION for TARGET_DISP_DIR unless otherwise specified
TARGET_DISP_DIR ?= $(TARGET_KERNEL_VERSION)

# Copy Advanced SF Offsets Config if present
ifneq ($(wildcard device/qcom/common/vendor/display/$(TARGET_DISP_DIR)/advanced_sf_offsets.xml),)
PRODUCT_COPY_FILES += \
    device/qcom/common/vendor/display/$(TARGET_DISP_DIR)/advanced_sf_offsets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/display/advanced_sf_offsets.xml
endif

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/display/$(TARGET_DISP_DIR)/display-vendor.mk)
$(call inherit-product, vendor/qcom/common/vendor/display/display-vendor.mk)
