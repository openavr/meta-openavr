#!/bin/bash

INSTALL="${1:-noinstall}"

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
    DEVCFG_DIR="${BASE}"
    IMAGE_NAME="${BASE}.squashfs"

    MACH_ID_SRC="Machine-ids/machine-id-${BASE}"
    MACH_ID_DST="${DEVCFG_DIR}/etc/machine-id"

    set -e
    set -x

    rm -f "${IMAGE_NAME}"
    rm -rf "${BASE}"

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
    # Need to use `-all-root` so that no files/dirs are created as user running the
    # script (which causes ownership issues when the overlayfs is created on the
    # device.
    #
    mksquashfs "${DEVCFG_DIR}" "${IMAGE_NAME}" -all-root
    set +x

    if [ "${INSTALL}" == "install" ]
    then
        ping -c 1 -O ${HOSTNAME} \
            && scp "${IMAGE_NAME}" ${HOSTNAME}:/config/ \
            && ssh ${HOSTNAME} 'sync && reboot' || :
    fi
}

mkdir -p Machine-ids

for i in $(seq 1 6)
do
    sernum=$(printf "%04d" "${i}")
    create_devcfg_image "${sernum}"
done
