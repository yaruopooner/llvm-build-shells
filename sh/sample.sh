# -*- mode: shell-script ; coding: utf-8-unix -*-
#! /bin/sh

. ./llvm-builder.sh

declare -r _LLVM_VERSION="${1-600}"
declare -r _PROJECT_PATH=$( cd $(dirname ${0}) && cd .. && pwd )
declare -r _PATCH_PATH="${_PROJECT_PATH}/patch"

# please refer document. : ../patch/details.org


# echo "llvm/tools/clang/;${_PATCH_PATH}/bugfix000.patch"

# executeBuilder --help

# executeBuilder --checkout --patch --configure --build --llvmVersion "${_LLVM_VERSION}" --patchApplyLocation "llvm/" --patchPath "${_PATCH_PATH}/invalidate-mmap.patch" --buildType "Debug" > llvm-build.log 2>&1

# executeBuilder --checkout --patch --configure --build --llvmVersion "${_LLVM_VERSION}" --patchInfo "llvm/tools/clang/;${_PATCH_PATH}/bugfix000.patch" --patchInfo "llvm/;${_PATCH_PATH}/invalidate-mmap.patch" > llvm-build.log 2>&1
executeBuilder --checkout --patch --configure --build --llvmVersion "${_LLVM_VERSION}" --patchInfo "llvm/tools/clang/;${_PATCH_PATH}/bugfix000.patch" > llvm-build.log 2>&1

# executeBuilder --checkout --patch --llvmVersion "${_LLVM_VERSION}" --patchApplyLocation "llvm/" --patchPath "${_PATCH_PATH}/invalidate-mmap.patch" > llvm-build-prepare.log 2>&1
# executeBuilder --configure --build --llvmVersion "${_LLVM_VERSION}" --buildType "Debug" --projectBuilder "cmake" > llvm-build-debug.log 2>&1
# executeBuilder --configure --build --llvmVersion "${_LLVM_VERSION}" --buildType "Release" --projectBuilder "cmake" > llvm-build-release.log 2>&1

