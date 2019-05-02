# -*- mode: shell-script ; coding: utf-8-unix -*-
#! /bin/sh

. ./llvm-builder.sh

declare -r _LLVM_VERSION="${1-800}"
declare -r _PROJECT_PATH=$( cd $(dirname ${0}) && cd .. && pwd )
declare -r _PATCH_PATH="${_PROJECT_PATH}/patch"
declare -r _START_DATE=$( date +%Y-%m%d-%H%M )
declare -r _LOG_FILE="llvm-build_${_START_DATE}.log"

# please refer document. : ../patch/details.org


# echo "llvm/tools/clang/;${_PATCH_PATH}/bugfix000.patch"

# executeBuilder --help

# executeBuilder --checkout --patch --configure --build --llvmVersion "${_LLVM_VERSION}" --patchApplyLocation "llvm/" --patchPath "${_PATCH_PATH}/invalidate-mmap.patch" --buildType "Debug" 2>&1 | tee "${_LOG_FILE}"

# executeBuilder --checkout --patch --configure --build --llvmVersion "${_LLVM_VERSION}" --patchInfo "llvm/tools/clang/;${_PATCH_PATH}/bugfix000.patch" --patchInfo "llvm/;${_PATCH_PATH}/invalidate-mmap.patch" 2>&1 | tee "${_LOG_FILE}"
executeBuilder --checkout --patch --configure --build --llvmVersion "${_LLVM_VERSION}" --patchInfo "llvm/tools/clang/;${_PATCH_PATH}/bugfix000.patch" 2>&1 | tee "${_LOG_FILE}"

# executeBuilder --checkout --patch --llvmVersion "${_LLVM_VERSION}" --patchApplyLocation "llvm/" --patchPath "${_PATCH_PATH}/invalidate-mmap.patch" 2>&1 | tee "prepare-${_LOG_FILE}"
# executeBuilder --configure --build --llvmVersion "${_LLVM_VERSION}" --buildType "Debug" --projectBuilder "cmake" 2>&1 | tee "debug-${_LOG_FILE}"
# executeBuilder --configure --build --llvmVersion "${_LLVM_VERSION}" --buildType "Release" --projectBuilder "cmake" 2>&1 | tee "release-${_LOG_FILE}"

