FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot:"

# The build for bb-ai64 is multi-config and will also build this recipe for the
# k3r5 MACHINE, but that breaks if .inc file is applied, hence the conditional
# require here.
require ${@bb.utils.contains_any("MACHINE", "beagleboneai beaglebone-ai64", "u-boot-openavr.inc", "", d)}

KERNEL_BOOTCMD:beagleboneai = "bootz"
KERNEL_BOOTCMD:beaglebone-ai64 = "booti"
