#!/bin/bash

set -o errexit

[[ $# -eq 0 ]] || exit 1

TOP=$(realpath ../../..)

export KBUILD_BUILD_USER=grapheneos
export KBUILD_BUILD_HOST=grapheneos

PATH="$TOP/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin:$PATH"
PATH="$TOP/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin:$PATH"
PATH="$TOP/prebuilts/clang/host/linux-x86/clang-r353983c/bin:$PATH"
PATH="$TOP/prebuilts/misc/linux-x86/lz4:$PATH"
PATH="$TOP/prebuilts/misc/linux-x86/dtc:$PATH"
PATH="$TOP/prebuilts/misc/linux-x86/libufdt:$PATH"
export LD_LIBRARY_PATH="$TOP/prebuilts/clang/host/linux-x86/clang-r353983c/lib64:$LD_LIBRARY_PATH"

make O=out ARCH=arm64 bonito_defconfig

make -j$(nproc) \
    O=out \
    ARCH=arm64 \
    CC=clang \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-androideabi-

rm -rf "$TOP/device/google/bonito-kernel"
mkdir -p "$TOP/device/google/bonito-kernel"
cp out/arch/arm64/boot/{dtbo.img,Image.lz4} "$TOP/device/google/bonito-kernel"
cp out/arch/arm64/boot/dts/qcom/sdm670.dtb "$TOP/device/google/bonito-kernel"
