FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-ti-staging-2023.04:"

SRC_URI:append:beaglebone-ai64 = " \
    file://bb-ai64-fdtfile.cfg \
    file://disable-efi.cfg \
    file://legacy-boot.cfg \
"
