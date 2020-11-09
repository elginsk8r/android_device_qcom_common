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

BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_DRIVER_STATE_CTRL_PARAM := "/dev/wlan"
WIFI_DRIVER_STATE_ON := "ON"
WIFI_DRIVER_STATE_OFF := "OFF"
WPA_SUPPLICANT_VERSION := VER_0_8_X

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml

PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    fstman \
    fstman.ini \
    hostapd \
    hostapd.accept \
    hostapd.deny \
    hostapd_cli \
    hostapd_default.conf \
    libqsap_sdk \
    libwifi-hal-qcom \
    sigma_dut \
    wpa_supplicant \
    wpa_supplicant.conf

PRODUCT_PACKAGES += \
    android.hardware.wifi.supplicant-V1-ndk.vendor \
    vendor.qti.hardware.wifi.supplicant-V1-ndk.vendor

ifneq ($(filter lahaina,$(TARGET_BOARD_PLATFORM)),)
PRODUCT_PACKAGES += \
    init.vendor.wlan.rc
endif

# Enable IEEE 802.11ax support
ifneq ($(filter kona $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
CONFIG_IEEE80211AX := true
endif

# IPACM
ifneq ($(filter hardware/qcom-caf/$(QCOM_HARDWARE_VARIANT)/data-ipa-cfg-mgr,$(PRODUCT_SOONG_NAMESPACES)),)
    $(call inherit-product, hardware/qcom-caf/$(QCOM_HARDWARE_VARIANT)/data-ipa-cfg-mgr/ipacm_vendor_product.mk)
else ifneq ($(filter vendor/qcom/opensource/data-ipa-cfg-mgr,$(PRODUCT_SOONG_NAMESPACES)),)
    $(call inherit-product, vendor/qcom/opensource/data-ipa-cfg-mgr/ipacm_vendor_product.mk)
endif

# Include QCOM WLAN makefiles.
ifneq ($(filter sdm845,$(TARGET_BOARD_PLATFORM)),)
-include device/qcom/wlan/skunk/wlan.mk
else ifneq ($(filter msm8998 sdm660,$(TARGET_BOARD_PLATFORM)),)
-include device/qcom/wlan/sdm660_64/wlan.mk
else ifneq ($(filter sm6150,$(TARGET_BOARD_PLATFORM)),)
-include device/qcom/wlan/talos/wlan.mk
else
-include device/qcom/wlan/$(TARGET_BOARD_PLATFORM)/wlan.mk
endif

# Get non-open-source specific aspects.
ifneq ($(filter $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
$(call inherit-product-if-exists, vendor/qcom/common/vendor/wlan/wlan-vendor.mk)
else
$(call inherit-product-if-exists, vendor/qcom/common/vendor/wlan-legacy/wlan-legacy-vendor.mk)
endif
