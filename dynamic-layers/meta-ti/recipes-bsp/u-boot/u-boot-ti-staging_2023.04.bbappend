FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-ti-staging-2023.04:"

UBOOT_CONFIG_FRAGMENTS:beaglebone-ai64 = "j721e_beagleboneai64_a72.config"
UBOOT_CONFIG_FRAGMENTS:beaglebone-ai64-k3r5 = "j721e_beagleboneai64_r5.config"

SRC_URI_PATCHES = " \
    file://0001-Add-bbai-64-config-options-for-OpenAVR.patch \
"

SRC_URI:append:beaglebone-ai64 = " ${SRC_URI_PATCHES}"
SRC_URI:append:beaglebone-ai64-k3r5 = " ${SRC_URI_PATCHES}"
