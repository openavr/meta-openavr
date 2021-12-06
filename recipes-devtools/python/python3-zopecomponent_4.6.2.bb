DESCRIPTIO = "Zope Component Architecture"
HOMEPAGE = "https://github.com/zopefoundation/zope.component"
LICENSE = "ZPL-2.1"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=78ccb3640dc841e1baecb3e27a6966b2"

PYPI_PACKAGE = "zope.component"

inherit pypi setuptools3

SRC_URI[md5sum] = "a2ff90ec57119f0e568fa4aa64a57ebd"
SRC_URI[sha256sum] = "91628918218b3e6f6323de2a7b845e09ddc5cae131c034896c051b084bba3c92"

RDEPENDS:${PN} = "\
    python3-zopeevent \
    python3-zopedeprecation \
    python3-zopehookable \
    python3-zopedeferredimport \
    python3-zopeinterface \
"
