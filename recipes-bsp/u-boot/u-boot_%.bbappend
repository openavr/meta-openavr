FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:rpi = " \
    file://0001-Increase-SYS_BOOTM_LEN.patch \
    file://bootcmd.cfg \
"

SRC_URI:append:beaglebone-yocto = " file://boot.cmd.in"

KERNEL_BOOTCMD:beaglebone-yocto = "bootz"

UBOOT_ENV:beaglebone-yocto = "boot"
UBOOT_ENV_SUFFIX:beaglebone-yocto = "scr"
UBOOT_ENV_SRC_SUFFIX:beaglebone-yocto = "cmd"

do_compile:prepend:beaglebone-yocto() {
    sed -e 's/@@KERNEL_IMAGETYPE@@/${KERNEL_IMAGETYPE}/' \
        -e 's/@@KERNEL_BOOTCMD@@/${KERNEL_BOOTCMD}/' \
        -e 's/@@DEBUG_OPENAVR_INIT@@/${DEBUG_OPENAVR_INIT}/' \
        "${WORKDIR}/boot.cmd.in" > "${WORKDIR}/boot.cmd"
}
