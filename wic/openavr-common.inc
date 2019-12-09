# short-description: Common partitions for OpenAVR images.

# Boot files are located in the first vfat partition.
part --source bootimg-partition --ondisk mmcblk0 --fstype=vfat --label boot --active --align 1024 --fixed-size 128 --sourceparams="loader=u-boot"

part --source rootfs --fstype=squashfs --align 1024
part --fstype=ext4 --label config  --align 1024 --size 64
part --fstype=ext4 --label data  --align 1024 --size 20
