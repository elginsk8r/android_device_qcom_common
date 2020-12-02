# Copyright 2023 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

all_vendor_components := \
	adreno \
	alarm \
	audio \
	charging \
	display \
	gps \
	keymaster \
	media \
	perf \
	qseecomd \
	telephony \
    usb \
	vibrator \
	wlan

target_vendor_components := $(filter $(all_vendor_components),$(TARGET_COMMON_QTI_COMPONENTS))

# QTI Common Components
$(foreach component,$(target_vendor_components),\
	$(eval PRODUCT_SOONG_NAMESPACES += device/qcom/common/vendor/$(component)) \
	$(eval include device/qcom/common/vendor/$(component)/qti-$(component).mk))

# SECCOMP Extensions
PRODUCT_COPY_FILES += \
    device/qcom/common/vendor/seccomp/codec2.software.ext.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/codec2.software.ext.policy \
    device/qcom/common/vendor/seccomp/codec2.vendor.ext.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/codec2.vendor.ext.policy \
    device/qcom/common/vendor/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/qcom/common/vendor/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy
