#!/bin/sh

#
# Before we can verify certificates used to validate file signatures, the
# system needs a relatively current date and time. There are a multiple places
# that can be obtained:
#
#  * /config/timestamp
#        This should be updated periodically by the main os so as to keep the
#        time updated. Hopefully, the system time will be updated with via NTP
#        and will be fairly accurate.
#
#  * /etc/build
#        (in the DATETIME field)
#        This is set to the date and time that the build of the image was started,
#        so will be different for each build.
#
#  * /etc/timestamp
#        This is set during build time by Bitbake, but is set to a const value to
#        enable reproducible builds. This could be changed in the build configuration
#        but that would have a ripple effect through many packages in the system.
#        Thus, it's best to not change it.
#
# Of the different sources, the value with the highest value will be used.
#
set_system_datetime()
{
    SYSTIME=$(/bin/date -u "+%4Y%2m%2d%2H%2M%2S")

    if [ -f /config/timestamp ]
    then
        TIMESTAMP=$(/bin/cat /config/timestamp)
        [ ${SYSTIME} -lt ${TIMESTAMP} ] && SYSTIME=${TIMESTAMP}
    fi

    if [ -f /etc/build ]
    then
        TIMESTAMP=$(/usr/bin/awk '/^DATETIME/ {print $3}' /etc/build)
        [ ${SYSTIME} -lt ${TIMESTAMP} ] && SYSTIME=${TIMESTAMP}
    fi

    if [ -f /etc/timestamp ]
    then
        TIMESTAMP=$(/bin/cat /etc/timestamp)
        [ ${SYSTIME} -lt ${TIMESTAMP} ] && SYSTIME=${TIMESTAMP}
    fi

    /bin/date -u ${SYSTIME:4:8}${SYSTIME:0:4}.${SYSTIME:(-2)}
}

check_single_file()
{
    if [ $# -gt 1 ]
    then
        echo "too many files: $@" 1>&2
        return 2
    fi

    if [ ! -e $1 ]
    then
        echo "Missing file: $1" 1>&2
        return 1
    fi
}

#
# TODO: This should probably be converted to a generic function
#       that can be reused to setup multiple squashfs images with
#       dm-verify. For now, it is devcfg specific.
#
setup_devcfg_dm_verity()
{
    TMPDIR="$1"
    DEVCFG=$(echo /config/devcfg-*.squashfs)

    check_single_file ${DEVCFG} || return 1

    DEVCFG_INFO="${TMPDIR}/$(basename ${DEVCFG}).info"

    SIGNCRT="${TMPDIR}/devcfg-signing.crt"
    SIGNPUB="${TMPDIR}/devcfg-signing.pub"

    META_OFFSET=$(( $(stat -c '%s' ${DEVCFG}) - 4096 ))

    # Extract the meta data tarball from the end of the squashfs file (last 4K)
    dd if=${DEVCFG} bs=1 skip=${META_OFFSET} | tar -C ${TMPDIR} -xz || return 1

    # Verify the signing cert against the OpenAVR Root CA certs embedded
    # in the rootfs image.
    openssl verify ${SIGNCRT} || return 1

    # Verify the info file.
    openssl x509 -pubkey -in ${SIGNCRT} > ${SIGNPUB}
    openssl dgst -sha256 -verify ${SIGNPUB} \
        -signature ${DEVCFG_INFO}.sig ${DEVCFG_INFO} || return 1

    # Now that we trust the ${DEVCF}.info file, we can source it to use the
    # ROOT_HASH and DATA_SIZE variables in it.
    source ${DEVCFG_INFO}

    # Since we trust the info file, we explicitly trust the dm-verity
    # ROOT_HASH of the squashfs and can mount the squashfs.
    veritysetup --hash-offset ${DATA_SIZE} \
        create vdevcfg ${DEVCFG} ${DEVCFG} ${ROOT_HASH} || return 1
}

set -x

PATH=/sbin:/bin:/usr/sbin:/usr/bin
export PATH

mkdir -p /proc
mkdir -p /sys

mount -t proc proc /proc
mount -t sysfs sysfs /sys

mkdir -p /dev
mount -t devtmpfs none /dev

mkdir -p /dev/pts
mount -t devpts devpts /dev/pts

while ! test -f /sys/block/mmcblk0/device/type
do
    echo "Waiting for block device: mmcblk0"
    sleep 1
done

# Find the SD card block device
if [ "$(cat /sys/block/mmcblk0/device/type)" == "SD" ]
then
    SD_BLK_DEV=mmcblk0
else
    SD_BLK_DEV=mmcblk1
fi

BOOT_DEV="/dev/${SD_BLK_DEV}p1"
RESC_DEV="/dev/${SD_BLK_DEV}p2"
CONF_DEV="/dev/${SD_BLK_DEV}p3"
DATA_DEV="/dev/${SD_BLK_DEV}p4"

mkdir -p /boot
mount -o ro -t vfat ${BOOT_DEV} /boot

# Device provisioning information goes in /config.
mkdir -p /config
mount -t ext4 -o rw ${CONF_DEV} /config

set_system_datetime

#
# TODO: Look for provisioning data. If not present, configure networking and
#       reach out to a provisioning server to get this node specific information.
#       This will require using something unique to this device (MAC, UUID,
#       Machine ID, etc).
#
#provision_device

#
# The /data partition data that persists across reboots and updates.
#
mkdir -p /data
mount -t ext4 -o rw ${DATA_DEV} /data

#
# Setup a tmpfs for files used to setup dm-verity hash validations
# for squashfs images.
#
DMV_TMPDIR="/dm-verity-tmp"
mkdir -p ${DMV_TMPDIR}
mount -t tmpfs -o size=10M tmpfs ${DMV_TMPDIR}

#
# Setup the rootfs.
# TODO: This needs the logic to deal with upgrades.
#
mkdir -p /rfs
#mount -o loop /boot/rootfs.squashfs-xz /rfs

# The Rescue rootfs partition
if setup_devcfg_dm_verity ${DMV_TMPDIR}
then
    mkdir -p /.rfs-overlay
    mount -t squashfs ${RESC_DEV} /.rfs-overlay

    mkdir -p /.cfg-overlay
    mount -t squashfs -o ro /dev/mapper/vdevcfg /.cfg-overlay

    # Stack the devcfg fs on top of the root fs using overlayfs
    # In `lowerdir=` option, right most dir is lowest in the stack.
    mount -t overlay overlay -o lowerdir=/.cfg-overlay:/.rfs-overlay /rfs

    MOVE_OVERLAYS="1"
else
    echo "Setup for unprovisioned device configuration"
    mount -t squashfs ${RESC_DEV} /rfs

    MOVE_OVERLAYS="0"
fi

if grep debug-openavr-init /proc/cmdline
then
    PS1="DEBUG: OpenAVR Init: ${PS1}"
    export PS1

    echo "Exit shell to continue booting into full system."
    sh
fi

# Done with the dm-verity tmpfs
umount ${DMV_TMPDIR}

mount --move /proc /rfs/proc
mount --move /sys /rfs/sys
mount --move /dev /rfs/dev

if [ "${MOVE_OVERLAYS}" == "1" ]
then
    mount --move /.rfs-overlay /rfs/.rfs-overlay
    mount --move /.cfg-overlay /rfs/.cfg-overlay
fi

mount --move /boot /rfs/boot
mount --move /config /rfs/config
mount --move /data /rfs/data

if [ ! -e /rfs/data/etc-hostname ]
then
    HOSTNAME="openavr-$(grep '^Serial' /rfs/proc/cpuinfo | sha256sum | cut -c -6)"

    if [ "${HOSTNAME}" != "openavr-" ]
    then
        echo "${HOSTNAME}" >/rfs/data/etc-hostname
        sed -e "s/^\(127[.]0[.]1[.]1\).*$/\1 ${HOSTNAME}/" /rfs/etc/hosts >/rfs/data/etc-hosts
    fi
fi

if [ -e /rfs/data/etc-hostname ]
then
    mount --bind -o ro /rfs/data/etc-hostname /rfs/etc/hostname
fi

if [ -e /rfs/data/etc-hosts ]
then
    mount --bind -o ro /rfs/data/etc-hosts /rfs/etc/hosts
fi

#
# Switch over to the real rootfs image and start up systemd
#
exec /sbin/switch_root /rfs /sbin/init
