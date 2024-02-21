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

all_system_components := \
	alarm \
	audio \
	display \
	gps \
	media \
	perf \
    telephony \
    wfd

ifneq (,$(filter all, $(TARGET_SYSTEM_QTI_COMPONENTS)))
TARGET_SYSTEM_QTI_COMPONENTS := \
	$(all_system_components) \
    $(filter-out all,$(TARGET_SYSTEM_QTI_COMPONENTS))
endif

# QTI Common Components
$(foreach component,$(filter $(all_system_components),$(TARGET_SYSTEM_QTI_COMPONENTS)),\
	$(eval PRODUCT_SOONG_NAMESPACES += device/qcom/common/system/$(component)) \
	$(eval include device/qcom/common/system/$(component)/qti-$(component).mk))

# Permissions
PRODUCT_COPY_FILES += \
    device/qcom/common/privapp-permissions-qti.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-qti.xml \
    device/qcom/common/privapp-permissions-qti-system-ext.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-qti-system-ext.xml \
    device/qcom/common/qti_whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/qti_whitelist.xml \
    device/qcom/common/qti_whitelist_system_ext.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/sysconfig/qti_whitelist_system_ext.xml

# Public Libraries
PRODUCT_COPY_FILES += \
    device/qcom/common/public.libraries.product-qti.txt:$(TARGET_COPY_OUT_PRODUCT)/etc/public.libraries-qti.txt \
    device/qcom/common/public.libraries.system_ext-qti.txt:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/public.libraries-qti.txt
