SUMMARY = "Moquitto Server Configuration Files"
SECTION = "net/config"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS += "mosquitto"
RDEPENDS:${PN} += "mosquitto"

SRC_URI = " \
    file://mosquitto-openavr.conf \
    file://volatiles.99_mosquitto \
    file://mosquitto-volatiles.conf \
"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${sysconfdir}/mosquitto/conf.d
    install -m 0644 ${S}/mosquitto-openavr.conf ${D}${sysconfdir}/mosquitto/conf.d

    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -d ${D}${sysconfdir}/tmpfiles.d/
        install -m 0644 ${S}/mosquitto-volatiles.conf ${D}${sysconfdir}/tmpfiles.d/
    else
        install -d ${D}${sysconfdir}/default/volatiles
        install -m 0644 ${S}/volatiles.99_mosquitto ${D}${sysconfdir}/default/volatiles/99_mosquitto
    fi
}
