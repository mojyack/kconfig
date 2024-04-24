#!/bin/zsh

# $1 kernel
# $2 dtb
# $3 output

kernel_blob="/tmp/zImage"
cat $1 $2 > $kernel_blob

empty_ramdisk="/tmp/ramdisk.gz"
echo . | cpio -o -H newc | gzip -c > $empty_ramdisk

cmdline="root=PARTUUID=d8e6753a-e694-66cc-f02f-d3030b86f5d2 rw rootwait loglevel=3 mitigations=off console=ttyMSM0,115200 boot_delay=500"

args=(
    --base 0
    --kernel_offset 0x8000
    --ramdisk_offset 0x01000000
    --tags_offset 0x00000100
    --pagesize 4096
    --second_offset 0x00f00000
    --cmdline \"$cmdline\"
    --os_patch_level "2019-09-21"
    --kernel $kernel_blob
    --ramdisk $empty_ramdisk
    --output $3
)

exec ${0:a:h}/mkbootimg/mkbootimg $args
