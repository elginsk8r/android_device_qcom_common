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

ifneq ($(filter sm6150 msmnile kona,$(TARGET_BOARD_PLATFORM)),)
TARGET_DISABLE_C2_CODEC ?= true
endif

ifeq ($(TARGET_DISABLE_C2_CODEC),true)
PRODUCT_ODM_PROPERTIES += \
    debug.stagefright.ccodec=0
endif

# Inherit configuration from the HAL.
ifneq ($(filter $(QCOM_SOONG_NAMESPACE),$(PRODUCT_SOONG_NAMESPACES)),)
    $(call inherit-product-if-exists, $(QCOM_SOONG_NAMESPACE)/media/product.mk)
endif

ifneq ($(filter $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
# Enable 64-bit mediaserver
PRODUCT_VENDOR_PROPERTIES += \
    ro.mediaserver.64b.enable=true
else
# Manifest
ifneq ($(TARGET_USES_CUSTOM_C2_MANIFEST), true)
DEVICE_MANIFEST_FILE += \
    device/qcom/common/vendor/media/legacy/c2_manifest_vendor.xml
endif
endif

# Media Codecs
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_le.xml

ifneq ($(filter $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
PRODUCT_COPY_FILES += \
    device/qcom/common/vendor/media/media_codecs_c2_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_c2_audio.xml
endif

# Media Profiles
ifneq ($(filter-out $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
PRODUCT_COPY_FILES += \
    device/qcom/common/vendor/media/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml
endif

# Packages
PRODUCT_PACKAGES += \
    libavservices_minijail.vendor \
    libgui_vendor \
    libstagefright_softomx.vendor \
    libstagefrighthw

ifneq ($(filter $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
# Packages
PRODUCT_PACKAGES += \
    android.hardware.media.c2@1.2.vendor
else 
PRODUCT_PACKAGES += \
    libcodec2_hidl@1.0.vendor \
    libcodec2_vndk.vendor
endif

# Properties
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    media.settings.xml=/vendor/etc/media_profiles_vendor.xml \
    media.stagefright.thumbnail.prefer_hw_codecs=true \
    ro.media.recorder-max-base-layer-fps=60

# Media Init
ifneq ($(filter $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
PRODUCT_COPY_FILES += \
    device/qcom/common/vendor/media/init.qti.media.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qti.media.sh
else ifneq ($(filter $(UM_5_4_FAMILY),$(TARGET_BOARD_PLATFORM)),)
PRODUCT_COPY_FILES += \
    device/qcom/common/vendor/media/5.4/init.qti.media.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qti.media.sh
endif

# Get non-open-source specific aspects.
ifneq ($(filter $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
$(call inherit-product-if-exists, vendor/qcom/common/vendor/media/media-vendor.mk)
else ifneq ($(filter $(UM_5_4_FAMILY),$(TARGET_BOARD_PLATFORM)),)
$(call inherit-product-if-exists, vendor/qcom/common/vendor/media-5.4/media-5.4-vendor.mk)
else
$(call inherit-product-if-exists, vendor/qcom/common/vendor/media-legacy/media-legacy-vendor.mk)
endif
