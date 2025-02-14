FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot:"

# The build for by-ai is multi-config and will also build this recipe for the
# k3r5 MACHINE, but that breaks if .inc file is applied, hence the conditional
# require here.
require ${@bb.utils.contains_any("MACHINE", "beagley-ai", "u-boot-openavr.inc", "", d)}

# KERNEL_BOOTCMD:beagley-ai = "bootz"

SRC_URI:append = "\
    file://uboot-openavr.config;subdir=git/configs \
"

UBOOT_CONFIG_FRAGMENTS:append = "\
    uboot-openavr.config \
"
