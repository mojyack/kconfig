#!/bin/zsh

if [[ ! -e $1 || ! -e $2 ]]; then
    echo "no output or install dir"
    exit 1
fi

src="https://github.com/patjak/facetimehd"

if [[ ! -e facetimehd ]]; then
    git clone --depth=1 "$src"
fi

cd facetimehd
make CC=clang LLVM=1 KDIR=/usr/src/linux O="$1" -j8
INSTALL_MOD_PATH="$2" make CC=clang LLVM=1 KDIR=/usr/src/linux O="$1" install
