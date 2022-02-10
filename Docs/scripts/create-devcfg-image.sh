#!/bin/bash

INSTALL="${1:-noinstall}"

SIGNING_KEY="${SIGNING_KEY:-$(realpath devcfg-signing.key)}"
SIGNING_CRT="${SIGNING_CRT:-$(realpath devcfg-signing.crt)}"

#
# Convert the output of `veritysetup format` into "Key=Value" data which can
# be sourced into a shell script for easier access.
#
function process_verity()
{
    read header
    printf "#\n# $header\n#\n"

    local IFS=":"
    while read KEY VAL
    do
        printf "%s=%s\n" \
            "$(echo "$KEY" | tr '[:lower:]' '[:upper:]' | tr ' ' '_')" \
            "$(echo "$VAL" | tr -d ' \t')"
    done
    echo "DATA_SIZE=${SIZE}"
}


function create_devcfg_image()
{
    DEV_SER_NUM="${1:-0001}"

    HOSTNAME="openavr-${DEV_SER_NUM}"

    echo "############################################"
    echo "#"
    echo "#  Generating devcfg for: ${HOSTNAME}"
    echo "#"
    echo "############################################"

    BASE="devcfg-${DEV_SER_NUM}"
    rm -rf "${BASE}"
    mkdir -p "${BASE}"
    pushd "${BASE}"

    ln -s ${SIGNING_CRT} devcfg-signing.crt

    DEVCFG_DIR="devcfg"
    IMAGE_NAME="${BASE}.squashfs"

    MACH_ID_SRC="../Machine-ids/machine-id-${BASE}"
    MACH_ID_DST="${DEVCFG_DIR}/etc/machine-id"

    set -e
    set -x

    mkdir -p "${DEVCFG_DIR}/etc"

    if [ -f "${MACH_ID_SRC}" ]
    then
        cp "${MACH_ID_SRC}" "${MACH_ID_DST}"
    else
        systemd-machine-id-setup --root="${DEVCFG_DIR}"
        cp "${MACH_ID_DST}" "${MACH_ID_SRC}"
    fi

    echo "${HOSTNAME}" > ${DEVCFG_DIR}/etc/hostname

    cat >${DEVCFG_DIR}/etc/hosts <<-EOF
	127.0.0.1       localhost.localdomain     localhost
	127.0.1.1       ${HOSTNAME}

	# The following lines are desirable for IPv6 capable hosts
	::1     localhost ip6-localhost ip6-loopback
	fe00::0 ip6-localnet
	ff00::0 ip6-mcastprefix
	ff02::1 ip6-allnodes
	ff02::2 ip6-allrouters
	EOF

    #
    # Need to use `-all-root` so that no files/dirs are created as user running
    # the script (which causes ownership issues when the overlayfs is created
    # on the device.
    #
    mksquashfs "${DEVCFG_DIR}" "${IMAGE_NAME}" -all-root

    #
    # Create the dm-verity hashing data.
    #
    SIZE=$(stat -c '%s' ${IMAGE_NAME})
    veritysetup format --hash-offset ${SIZE} ${IMAGE_NAME} ${IMAGE_NAME} \
        | process_verity > ${IMAGE_NAME}.info

    (
        source ${IMAGE_NAME}.info
        veritysetup verify --hash-offset ${DATA_SIZE} ${IMAGE_NAME} \
            ${IMAGE_NAME} ${ROOT_HASH}
    ) || return 1

    openssl dgst -sha256 -sign ${SIGNING_KEY} ${IMAGE_NAME}.info \
        > ${IMAGE_NAME}.info.sig

    # Append a 4K block to the squashfs image which contains a tarball of the
    # crt, dm-verity info the signature of the dm-verify info.

    tar chzf ${IMAGE_NAME}.tgz --owner=root:0 --group=root:0 \
        ${IMAGE_NAME}.info ${IMAGE_NAME}.info.sig devcfg-signing.crt

    dd conv=sync bs=4K if=${IMAGE_NAME}.tgz >> ${IMAGE_NAME}

    if [ "${INSTALL}" == "install" ]
    then
        ping -c 1 -O ${HOSTNAME} \
            && scp "${IMAGE_NAME}" ${HOSTNAME}:/config/ \
            && ssh ${HOSTNAME} 'sync && reboot' || :
    fi
}

if [ ! -f ${SIGNING_KEY} ]
then
    echo "ERROR: No signing key found: ${SIGNING_KEY}"
    exit 1
fi

mkdir -p Machine-ids

for i in $(seq 1 6)
do
    sernum=$(printf "%04d" "${i}")
    create_devcfg_image "${sernum}"
    popd
done
