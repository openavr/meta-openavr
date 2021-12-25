FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot:"

SRC_URI:append:beagleboneai = " file://boot.cmd.in"

KERNEL_BOOTCMD:beagleboneai = "bootz"

UBOOT_ENV:beagleboneai = "boot"
UBOOT_ENV_SUFFIX:beagleboneai = "scr"
UBOOT_ENV_SRC_SUFFIX:beagleboneai = "cmd"

do_compile:prepend:beagleboneai() {
    sed -e 's/@@KERNEL_IMAGETYPE@@/${KERNEL_IMAGETYPE}/' \
        -e 's/@@KERNEL_BOOTCMD@@/${KERNEL_BOOTCMD}/' \
        "${WORKDIR}/boot.cmd.in" > "${WORKDIR}/boot.cmd"
}
