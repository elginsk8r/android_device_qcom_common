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

target_system_components := $(filter $(all_system_components),$(TARGET_COMMON_QTI_COMPONENTS))

# QTI Common Components
$(foreach component,$(target_system_components),\
	$(eval PRODUCT_SOONG_NAMESPACES += device/qcom/common/system/$(component)) \
	$(eval include device/qcom/common/system/$(component)/qti-$(component).mk))

# Public Libraries
PRODUCT_COPY_FILES += \
    device/qcom/common/public.libraries.system_ext-qti.txt:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/public.libraries-qti.txt
