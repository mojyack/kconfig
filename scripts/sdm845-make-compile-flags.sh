#!/bin/zsh

target=compile_flags.txt
flags=(
    -I$PWD/include
    -I$PWD/include/uapi/linux
    -I$PWD/arch/arm64/include
    -I$PWD/arch/arm64/include/uapi
    -D__KERNEL__
    --target=aarch64-unknown-linux-musl

    # generated
    -I$PWD/build/arch/arm64/include/generated

    # downstream
    -I$PWD/include/uapi
    -I$PWD/include/uapi/media
    -I$PWD/drivers/media/platform/msm/camera_v3/cam_core
    -I$PWD/drivers/media/platform/msm/camera_v3/cam_utils
    -I$PWD/drivers/media/platform/msm/camera_v3/cam_smmu
    -I$PWD/drivers/media/platform/msm/camera_v3/cam_req_mgr
)

rm -f $target
for flag in $flags; do
    echo $flag >> $target
done

# from .config
while read line; do
    if [[ $line == '#'* || -z $line ]]; then
        continue
    fi
    echo -D$line >> $target
done < build/.config
