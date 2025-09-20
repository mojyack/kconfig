#!/bin/zsh

target=compile_flags.txt
flags=(
    -I$PWD/include
    -I$PWD/include/uapi/linux
    -I$PWD/arch/arm64/include
    -D__KERNEL__
    -DCONFIG_MEDIA_CONTROLLER
    -DCONFIG_VIDEO_V4L2_SUBDEV_API

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
