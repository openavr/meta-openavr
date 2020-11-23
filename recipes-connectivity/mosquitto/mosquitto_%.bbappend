FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://mosquitto.conf"

do_install_append() {
    install -m 644 ${WORKDIR}/mosquitto.conf ${D}${sysconfdir}/mosquitto/
}
