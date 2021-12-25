FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:rpi = " file://rpi-bootm-size.patch"

SRC_URI:append:beaglebone-yocto = " file://boot.cmd.in"

KERNEL_BOOTCMD:beaglebone-yocto = "bootz"

UBOOT_ENV:beaglebone-yocto = "boot"
UBOOT_ENV_SUFFIX:beaglebone-yocto = "scr"
UBOOT_ENV_SRC_SUFFIX:beaglebone-yocto = "cmd"

do_compile:prepend:beaglebone-yocto() {
    sed -e 's/@@KERNEL_IMAGETYPE@@/${KERNEL_IMAGETYPE}/' \
        -e 's/@@KERNEL_BOOTCMD@@/${KERNEL_BOOTCMD}/' \
        "${WORKDIR}/boot.cmd.in" > "${WORKDIR}/boot.cmd"
}
