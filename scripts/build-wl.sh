#!/bin/zsh

patch='https://gitlab.archlinux.org/archlinux/packaging/packages/broadcom-wl-dkms.git/'
src="https://docs.broadcom.com/docs-and-downloads/docs/linux_sta/hybrid-v35_64-nodebug-pcoem-6_30_223_271.tar.gz"

git clone --depth=1 "$patch"
curl -o hybrid-v35_64-nodebug-pcoem.tar.gz "$src"

mkdir -p work
cd work
tar xvf ../hybrid-v35_64-nodebug-pcoem.tar.gz
for p (../broadcom-wl-dkms/*.patch); do patch -p1 < $p; done
doas make CC=clang GE_49=1 LLVM=1 KBUILD_DIR=/tmp/linux-$(uname -r)
