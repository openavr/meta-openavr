FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = "\
    file://overlayfs.cfg \
"

KERNEL_CONFIG_FRAGMENTS:append = "\
    ${WORKDIR}/overlayfs.cfg \
"
