# -*- mode: shell-script ; coding: utf-8-unix -*-
#! /bin/sh

. ./llvm-builder.sh

declare -r _LLVM_CHECKOUT_TAG="${1-llvmorg-9.0.0}"
declare -r _PROJECT_PATH=$( cd $(dirname ${0}) && cd .. && pwd )
declare -r _PATCH_PATH="${_PROJECT_PATH}/patch"
declare -r _START_DATE=$( date +%Y-%m%d-%H%M )
declare -r _LOG_FILE="llvm-build_${_START_DATE}.log"

# please refer document. : ../patch/details.org


# executeBuilder --help

# default
executeBuilder --checkout --llvmCheckoutTag "${_LLVM_CHECKOUT_TAG}" --patch --configure --build 2>&1 | tee "release-${_LOG_FILE}"

# full option
# executeBuilder --checkout --llvmCheckoutTag "${_LLVM_CHECKOUT_TAG}" --patch --configure --build --buildType "Release" --projectBuilder "cmake" 2>&1 | tee "release-${_LOG_FILE}"

