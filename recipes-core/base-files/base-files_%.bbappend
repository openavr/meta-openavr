FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

hostname = "openavr-dev"

do_install:append() {
    install -m 755 -d ${D}/config
    install -m 755 -d ${D}/data
    install -m 755 -d ${D}/.rfs-overlay
    install -m 755 -d ${D}/.cfg-overlay
}

FILES:${PN} += "\
    /config \
    /data \
    /.rfs-overlay \
    /.cfg-overlay \
"
