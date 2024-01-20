FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-ti-staging-2023.04:"

UBOOT_CONFIG_FRAGMENTS:beaglebone-ai64 = "j721e_beagleboneai64_a72.config"
UBOOT_CONFIG_FRAGMENTS:beaglebone-ai64-k3r5 = "j721e_beagleboneai64_r5.config"

SRC_URI:append:beaglebone-ai64 = " \
    file://bb-ai64-fdtfile.cfg \
    file://disable-efi.cfg \
    file://legacy-boot.cfg \
"

# FIXME: Almost all of these patches have been dropped by Robert C Nelson in his
# fork of u-boot-ti-staging. Not sure why yet (2023-09-19)

SRC_URI:append:beaglebone-ai64 = " \
    file://0001-arch-arm-mach-k3-j721e-add-support-for-UDA-FS.patch \
    file://0002-ti_armv7_common.h-disable-TI_MMC-boot-target-it-just.patch \
    file://0003-j721e_beagleboneai64-just-force-k3-j721e-beaglebonea.patch \
    file://0004-partial-revert-spl-dts-k3-j721e-sk.dtb-not-found-in-.patch \
    file://0005-board-ti-j721e-evm.c-default-to-BBONEAI-64-B0.patch \
    file://0006-j721e_beagleboneai64-need-run-findfdt-to-set-board-f.patch \
    file://0007-bbb.io-make-sure-all-env-follow-ti-dtb.patch \
    file://0008-env_default-Allow-CONFIG_EXTRA_ENV_TEXT-to-override-.patch \
    file://0009-arm-mach-k3-am625-Add-support-for-UDA-FS.patch \
    file://0010-board-ti-am62x-Add-am62x_beagleplay_-defconfigs-and-.patch \
    file://0011-2023.04-beagleplay-these-small-configs-still-need-to.patch \
    file://0012-configs-beagleplay_a53.config-drop-CONFIG_DFU_SF.patch \
    file://0013-board-Change-reported-board-name-to-BBONEAI-64.patch \
"
