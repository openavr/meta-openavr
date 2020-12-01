DESCRIPTION = "Certbot ACME Python library"
HOMEPAGE = "https://github.com/certbot/certbot/"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=d2c2a5517cd7fd190a1aa6dfa23abb7a"

inherit pypi setuptools3

SRC_URI[md5sum] = "0d6e5e7a7a82bd69112321fb98fc14c0"
SRC_URI[sha256sum] = "38a1630c98e144136c62eec4d2c545a1bdb1a3cd4eca82214be6b83a1f5a161f"

RDEPENDS_${PN} = "\
    python3-requests-toolbelt \
    python3-cryptography \
    python3-pyopenssl \
"
