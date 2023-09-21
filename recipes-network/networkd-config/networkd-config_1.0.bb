SUMMARY = "Networkd Configuration Files"
SECTION = "net/config"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://75-eth0.network \
    file://75-eth1.network \
    file://75-eth-usb1.network \
    file://75-eth-usb2.network \
    file://75-http.dnssd \
"

S = "${WORKDIR}"

do_install() {
    install -m 0755 -d ${D}${systemd_unitdir}/network
    install -m 0644 ${S}/75-eth0.network ${D}${systemd_unitdir}/network
    install -m 0644 ${S}/75-eth1.network ${D}${systemd_unitdir}/network
    install -m 0644 ${S}/75-eth-usb1.network ${D}${systemd_unitdir}/network
    install -m 0644 ${S}/75-eth-usb2.network ${D}${systemd_unitdir}/network

    install -m 0755 -d ${D}${systemd_unitdir}/dnssd
    install -m 0644 ${S}/75-http.dnssd ${D}${systemd_unitdir}/dnssd
}

FILES:${PN} += "\
    ${systemd_unitdir}/network \
    ${systemd_unitdir}/dnssd \
"
