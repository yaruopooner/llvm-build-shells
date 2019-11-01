# -*- mode: shell-script ; coding: utf-8-unix -*-
#! /bin/sh

. ./llvm-builder.sh

declare -r _LLVM_CHECKOUT_TAG="${1-llvmorg-7.0.0}"
declare -r _PROJECT_PATH=$( cd $(dirname ${0}) && cd .. && pwd )
declare -r _PATCH_PATH="${_PROJECT_PATH}/patch"
declare -r _START_DATE=$( date +%Y-%m%d-%H%M )
declare -r _LOG_FILE="llvm-build_${_START_DATE}.log"

# please refer document. : ../patch/details.org


# echo "llvm/tools/clang/;${_PATCH_PATH}/bugfix000.patch"

# executeBuilder --help

# executeBuilder --checkout --patch --configure --build --patchPath "${_PATCH_PATH}/invalidate-mmap.patch" --buildType "Debug" 2>&1 | tee "${_LOG_FILE}"

# executeBuilder --checkout --patch --configure --build --patchInfo "llvm/tools/clang/;${_PATCH_PATH}/bugfix000.patch" --patchInfo "llvm/;${_PATCH_PATH}/invalidate-mmap.patch" 2>&1 | tee "${_LOG_FILE}"
# executeBuilder --checkout --patch --configure --build --patchInfo "llvm/tools/clang/;${_PATCH_PATH}/bugfix000.patch" 2>&1 | tee "${_LOG_FILE}"
executeBuilder --checkout --llvmCheckoutTag "${_LLVM_CHECKOUT_TAG}" --patch 2>&1 | tee "${_LOG_FILE}"

# executeBuilder --checkout --patch --patchPath "${_PATCH_PATH}/invalidate-mmap.patch" 2>&1 | tee "prepare-${_LOG_FILE}"
# executeBuilder --configure --build --buildType "Debug" --projectBuilder "cmake" 2>&1 | tee "debug-${_LOG_FILE}"
# executeBuilder --configure --build --buildType "Release" --projectBuilder "cmake" 2>&1 | tee "release-${_LOG_FILE}"

