SRC_URI:append = " file://boot.cmd.in"

UBOOT_ENV = "boot"
UBOOT_ENV_SUFFIX = "scr"
UBOOT_ENV_SRC_SUFFIX = "cmd"

do_compile:prepend() {
    sed -e 's/@@KERNEL_IMAGETYPE@@/${KERNEL_IMAGETYPE}/' \
        -e 's/@@KERNEL_BOOTCMD@@/${KERNEL_BOOTCMD}/' \
        -e 's/@@DEBUG_OPENAVR_INIT@@/${DEBUG_OPENAVR_INIT}/' \
        "${WORKDIR}/boot.cmd.in" > "${WORKDIR}/boot.cmd"
}
