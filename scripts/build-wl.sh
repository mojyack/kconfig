#!/bin/zsh

if [[ ! -e $1 || ! -e $2 ]]; then
    echo "no output or install dir"
    exit 1
fi

patch='https://gitlab.archlinux.org/archlinux/packaging/packages/broadcom-wl-dkms.git/'
src="https://docs.broadcom.com/docs-and-downloads/docs/linux_sta/hybrid-v35_64-nodebug-pcoem-6_30_223_271.tar.gz"

if [[ ! -e broadcom-wl-dkms ]]; then
    git clone --depth=1 "$patch"
fi
if [[ ! -e hybrid-v35_64-nodebug-pcoem.tar.gz ]]; then
    curl -o hybrid-v35_64-nodebug-pcoem.tar.gz "$src"
    unpack=1
fi

mkdir -p work
cd work
if [[ $unpack == 1 ]]; then
    tar xvf ../hybrid-v35_64-nodebug-pcoem.tar.gz
    for p (../broadcom-wl-dkms/*.patch); do patch -p1 < $p; done
fi
make CC=clang GE_49=1 LLVM=1 KBUILD_DIR=/usr/src/linux O="$1"

mkdir -p "$2/kernel/drivers/net/wireless"
cp wl.ko "$2/kernel/drivers/net/wireless"
depmod -b "$2/../../.." "$2:t"
