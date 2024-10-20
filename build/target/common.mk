#
# Copyright 2020 Paranoid Android
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
#

include device/qcom/common/qcom_hardware.mk

# Components
ifneq (,$(filter all, $(TARGET_COMMON_QTI_COMPONENTS)))
TARGET_COMMON_QTI_COMPONENTS := \
	audio \
	display \
	perf \
    telephony \
    wfd \
    $(filter-out all,$(TARGET_COMMON_QTI_COMPONENTS))
endif
include device/qcom/common/build/target/system.mk
include device/qcom/common/build/target/vendor.mk
