FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

hostname = "openavr-dev"

do_install:append() {
    install -m 755 -d ${D}/config
    install -m 755 -d ${D}/data
}

FILES:${PN} += "\
    /config \
    /data \
"
