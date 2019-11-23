SUMMARY = "Networkd Configuration Files"
SECTION = "net/config"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://eth0.network \
"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/etc/systemd/network
    install -m 0644 ${S}/eth0.network ${D}/etc/systemd/network
}
