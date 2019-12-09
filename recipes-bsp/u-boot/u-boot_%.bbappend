FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# TODO: Use boot.scr instead of uEnv.txt.
#       See example recipe in meta-raspberrypi.

SRC_URI_append_beaglebone-yocto = " file://uEnv.txt"
UBOOT_ENV_beaglebone-yocto = "uEnv"

SRC_URI_append_rpi = " file://rpi-bootm-size.patch"
