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

# Flags
BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := default
ifeq ($(filter $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
LOC_HIDL_VERSION := 4.2
endif

# Inherit the GPS HAL.
ifneq ($(filter hardware/qcom-caf/$(QCOM_HARDWARE_VARIANT)/gps,$(PRODUCT_SOONG_NAMESPACES)),)
    $(call inherit-product-if-exists, $(QCOM_SOONG_NAMESPACE)/gps/gps_vendor_product.mk)
endif

# Overlays
PRODUCT_PACKAGES += \
    QCOMGPSFrameworksOverlay

# Packages
PRODUCT_PACKAGES += \
    android.frameworks.sensorservice@1.0.vendor

ifneq ($(filter $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
PRODUCT_PACKAGES += \
    android.hardware.gnss-V2-ndk.vendor
endif

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml

# Get non-open-source specific aspects.
ifneq ($(filter $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
$(call inherit-product-if-exists, vendor/qcom/common/vendor/gps/gps-vendor.mk)
else
$(call inherit-product-if-exists, vendor/qcom/common/vendor/gps-legacy/gps-legacy-vendor.mk)
endif
