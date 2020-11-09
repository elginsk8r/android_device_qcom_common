# Copyright (C) 2020 Paranoid Android
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

LOCAL_PATH := $(call my-dir)

ifneq ($(filter $(LOCAL_PATH),$(PRODUCT_SOONG_NAMESPACES)),)

include $(CLEAR_VARS)

ifneq ($(filter msm8998 sdm660,$(TARGET_BOARD_PLATFORM)),)
-include device/qcom/wlan/sdm660_64/AndroidBoardWlan.mk
else ifneq ($(filter sm6150,$(TARGET_BOARD_PLATFORM)),)
-include device/qcom/wlan/talos/AndroidBoardWlan.mk
else
-include device/qcom/wlan/$(TARGET_BOARD_PLATFORM)/AndroidBoardWlan.mk
endif

endif
