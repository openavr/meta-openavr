FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://mosquitto.conf"

do_install:append() {
    install -m 644 ${UNPACKDIR}/mosquitto.conf ${D}${sysconfdir}/mosquitto/
}
