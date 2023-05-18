#
# Copyright (C) 2023 Paranoid Android
#
# SPDX-License-Identifier: Apache-2.0
#

# Init script
PRODUCT_PACKAGES += \
    init.qcom.alarm.rc

# Manifest
DEVICE_MANIFEST_FILE += \
    device/qcom/common/vendor/alarm/alarm-manifest.xml

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/alarm/alarm-vendor.mk)
