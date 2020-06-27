BOARD_USES_ADRENO := true

# Tell HALs that we're compiling an AOSP build with an in-line kernel
TARGET_COMPILE_WITH_MSM_KERNEL := true

# Enable media extensions
TARGET_USES_MEDIA_EXTENSIONS := true

# Allow building audio encoders
TARGET_USES_QCOM_MM_AUDIO := true

# Enable ion
TARGET_USES_ION := true

# Enable color metadata
TARGET_USES_COLOR_METADATA := true

# Inherit late if components are not used
ifeq ($(TARGET_COMMON_QTI_COMPONENTS),)
include device/qcom/common/qcom_hardware.mk
endif
