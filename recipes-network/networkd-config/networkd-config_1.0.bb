SUMMARY = "Networkd Configuration Files"
SECTION = "net/config"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://75-eth0.network \
    file://75-eth1.network \
    file://75-enp1s0u1.network \
    file://75-enp1s0u2.network \
"

S = "${WORKDIR}"

do_install() {
    install -m 0755 -d ${D}${sysconfdir}/systemd/network
    install -m 0644 ${S}/75-eth0.network ${D}${sysconfdir}/systemd/network/75-eth0.network
    install -m 0644 ${S}/75-eth1.network ${D}${sysconfdir}/systemd/network/75-eth1.network
    install -m 0644 ${S}/75-enp1s0u1.network ${D}${sysconfdir}/systemd/network/75-enp1s0u1.network
    install -m 0644 ${S}/75-enp1s0u2.network ${D}${sysconfdir}/systemd/network/75-enp1s0u2.network

    install -m 0755 -d ${D}${sysconfdir}/resolved.conf.d
    install -m 0644 ${S}/mdns.conf ${D}${sysconfdir}/resolved.conf.d/mdns.conf
}
