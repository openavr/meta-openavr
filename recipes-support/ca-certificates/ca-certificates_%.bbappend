FILESEXTRAPATHS:prepend := "${ROOT_CA_CERT_DIR}:"

SRC_URI:append = " \
    file://root-ca-certs.tgz; \
"

do_install:prepend () {
    install -d ${D}${datadir}/ca-certificates
    install -m 0644 ${WORKDIR}/*.crt ${D}${datadir}/ca-certificates/
}
