# short-description: Common partitions for OpenAVR images.

# Boot files are located in the first vfat partition.
part --source bootimg-partition --ondisk mmcblk0 --fstype=vfat --label boot --active --align 4 --size 16 --sourceparams="loader=u-boot"

part --source rootfs --fstype=squashfs --align 4
part --fstype=ext4 --label config  --align 4 --size 64
part --fstype=ext4 --label data  --align 4 --size 2G
