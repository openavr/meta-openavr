FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = "\
    file://overlayfs.cfg \
    file://dm-verity.cfg \
"

KERNEL_CONFIG_FRAGMENTS:append = "\
    ${WORKDIR}/overlayfs.cfg \
    ${WORKDIR}/dm-verity.cfg \
"
