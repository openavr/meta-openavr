DESCRIPTION = "Certbot ACME client"
HOMEPAGE = "https://github.com/certbot/certbot/"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=16542115f15152bdc6d80c5b5d208e70"

inherit pypi setuptools3

SRC_URI[md5sum] = "b000d844ab584c63436a766a73f97bb5"
SRC_URI[sha256sum] = "2ff9bf7d9af381c7efee22dec2dd6938d9d8fddcc9e11682b86e734164a30b57"

RDEPENDS_${PN} = "\
    python3-acme \
    python3-josepy \
    python3-pkg-resources \
    python3-zopeinterface \
    python3-zopecomponent \
    python3-configobj \
    python3-configargparse \
    python3-parsedatetime \
    python3-pyrfc3339 \
    python3-distro \
"
