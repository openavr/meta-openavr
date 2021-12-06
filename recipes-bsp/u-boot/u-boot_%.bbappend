FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# TODO: Use boot.scr instead of uEnv.txt.
#       See example recipe in meta-raspberrypi.

SRC_URI:append:beaglebone-yocto = " file://uEnv.txt"
UBOOT_ENV:beaglebone-yocto = "uEnv"

SRC_URI:append:rpi = " file://rpi-bootm-size.patch"
