include device/qcom/common/qcom_boards.mk
include device/qcom/common/qcom_defs.mk

ifneq ($(filter msm8937 msm8953,$(UM_4_9_LEGACY_FAMILY)),)
UM_3_18_HAL_FAMILY := $(subst msm8937 msm8953,,$(UM_3_18_FAMILY))
endif
UM_3_18_HAL_FAMILY ?= $(UM_3_18_FAMILY)
ifneq ($(filter sdm660,$(UM_4_19_LEGACY_FAMILY)),)
UM_4_4_HAL_FAMILY := $(subst sdm660,,$(UM_4_4_FAMILY))
endif
UM_4_4_HAL_FAMILY ?= $(UM_4_4_FAMILY)

ifneq ($(filter $(UM_3_18_HAL_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := msm8996
else ifneq ($(filter $(UM_4_9_LEGACY_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := msm8953
else ifneq ($(filter $(UM_4_4_HAL_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := msm8998
else ifneq ($(filter $(UM_4_19_LEGACY_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := sdm660
else ifneq ($(filter $(UM_4_9_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := sdm845
else ifneq ($(filter $(UM_4_14_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := sm8150
else ifneq ($(filter $(UM_4_19_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := sm8250
else ifneq ($(filter $(UM_5_4_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := sm8350
else ifneq ($(filter $(UM_5_10_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := sm8450
else ifneq ($(filter $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := sm8550
else
    QCOM_HARDWARE_VARIANT := $(TARGET_BOARD_PLATFORM)
endif

ifneq ($(filter $(UM_3_18_HAL_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_KERNEL_VERSION := 3.18
else ifneq ($(filter $(UM_4_4_HAL_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_KERNEL_VERSION := 4.4
else ifneq ($(filter $(UM_4_9_FAMILY) $(UM_4_9_LEGACY_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_KERNEL_VERSION := 4.9
else ifneq ($(filter $(UM_4_14_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_KERNEL_VERSION := 4.14
else ifneq ($(filter $(UM_4_19_FAMILY) $(UM_4_19_LEGACY_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_KERNEL_VERSION := 4.19
else ifneq ($(filter $(UM_5_4_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_KERNEL_VERSION := 5.4
else ifneq ($(filter $(UM_5_10_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_KERNEL_VERSION := 5.10
else ifneq ($(filter $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_KERNEL_VERSION := 5.15
endif

ifneq ($(QCOM_KERNEL_VERSION),)
    ifeq ($(TARGET_KERNEL_VERSION),)
        TARGET_KERNEL_VERSION := $(QCOM_KERNEL_VERSION)
    endif
endif

# Allow a device to opt-out hardset of PRODUCT_SOONG_NAMESPACES
QCOM_SOONG_NAMESPACE ?= hardware/qcom-caf/$(QCOM_HARDWARE_VARIANT)
PRODUCT_SOONG_NAMESPACES += $(QCOM_SOONG_NAMESPACE)

# Audio
ifneq ($(filter $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    TARGET_USES_QCOM_AUDIO_AR ?= true
endif

# Dataservices
SOONG_CONFIG_NAMESPACES += rmnetctl
SOONG_CONFIG_rmnetctl += \
    old_rmnet_data
ifeq ($(filter $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    SOONG_CONFIG_rmnetctl_old_rmnet_data := true
endif
SOONG_CONFIG_rmnetctl_old_rmnet_data ?= false

ifneq ($(USE_DEVICE_SPECIFIC_DATASERVICES),true)
    PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/dataservices
endif

# Display
MASTER_SIDE_CP_TARGET_LIST := msm8996 $(UM_4_4_FAMILY) $(UM_4_9_FAMILY) $(UM_4_14_FAMILY) $(UM_4_19_FAMILY)
ifeq ($(filter $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    MSM_VIDC_TARGET_LIST := $(TARGET_BOARD_PLATFORM)
endif
SOONG_CONFIG_NAMESPACES += qtidisplay
SOONG_CONFIG_qtidisplay += \
    drmpp \
    headless \
    llvmsa \
    gralloc4 \
    displayconfig_enabled \
    udfps \
    default \
    var1 \
    var2 \
    var3

ifneq ($(filter $(UM_4_9_FAMILY) $(UM_4_14_FAMILY) $(UM_4_19_FAMILY) $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    # Enable DRM PP driver on UM platforms that support it
    SOONG_CONFIG_qtidisplay_drmpp := true
endif
SOONG_CONFIG_qtidisplay_drmpp ?= false
SOONG_CONFIG_qtidisplay_headless ?= false
SOONG_CONFIG_qtidisplay_llvmsa ?= false
ifneq ($(filter $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    # Enable Gralloc4 on UM platforms that support it
    SOONG_CONFIG_qtidisplay_gralloc4 := true
endif
SOONG_CONFIG_qtidisplay_gralloc4 ?= false
ifeq ($(filter $(UM_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
    # Enable displayconfig on every UM platform
    SOONG_CONFIG_qtidisplay_displayconfig_enabled := true
endif
SOONG_CONFIG_qtidisplay_displayconfig_enabled ?= false
SOONG_CONFIG_qtidisplay_udfps ?= false
SOONG_CONFIG_qtidisplay_default ?= true
SOONG_CONFIG_qtidisplay_var1 ?= false
SOONG_CONFIG_qtidisplay_var2 ?= false
SOONG_CONFIG_qtidisplay_var3 ?= false
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS ?= 0
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS += | (1 << 13)
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS += | (1 << 21)
ifneq ($(filter $(UM_4_9_FAMILY) $(UM_4_14_FAMILY) $(UM_4_19_FAMILY) $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS += | (1 << 27)
endif
ifneq ($(filter $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    TARGET_GRALLOC_HANDLE_HAS_CUSTOM_CONTENT_MD_RESERVED_SIZE ?= true
    TARGET_GRALLOC_HANDLE_HAS_RESERVED_SIZE ?= true
endif
TARGET_USES_DRM_PP := $(SOONG_CONFIG_qtidisplay_drmpp)

ifneq ($(filter $(QSSI_SUPPORTED_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/commonsys/display \
    vendor/qcom/opensource/commonsys-intf/display

ifeq ($(filter $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/display
endif

endif

# GPS
ifneq ($(filter gps,$(TARGET_COMMON_QTI_COMPONENTS)),)
USE_DEVICE_SPECIFIC_GPS ?= false
else
USE_DEVICE_SPECIFIC_GPS ?= true
endif

ifeq ($(USE_DEVICE_SPECIFIC_GPS),false)
    PRODUCT_SOONG_NAMESPACES += hardware/qcom-caf/$(QCOM_HARDWARE_VARIANT)/gps
endif

# IPACM
ifneq ($(USE_DEVICE_SPECIFIC_DATA_IPA_CFG_MGR),true)
    ifneq ($(filter $(LEGACY_UM_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
        PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/data-ipa-cfg-mgr
    else
        PRODUCT_SOONG_NAMESPACES += hardware/qcom-caf/$(QCOM_HARDWARE_VARIANT)/data-ipa-cfg-mgr
    endif
endif

# Vibrator HAL
$(call soong_config_set, vibrator, vibratortargets, vibratoraidlV2target)

# WiFi
PRODUCT_SOONG_NAMESPACES += hardware/qcom-caf/wlan
