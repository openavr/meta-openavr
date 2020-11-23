SUMMARY = "OpenAVR Reference OS Image with development tools"

IMAGE_LINGUAS = " "

LICENSE = "MIT"

include recipes-core/images/openavr-image.inc

IMAGE_INSTALL += " \
    packagegroup-openavr-dev \
"
