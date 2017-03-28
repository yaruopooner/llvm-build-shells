# -*- mode: shell-script ; coding: utf-8-unix -*-
#! /bin/sh

. ./llvm-builder.sh

declare -r _CLANG_VERSION="${1-400}"
declare -r _PROJECT_PATH=$( cd $(dirname ${0}) && cd .. && pwd )
declare -r _PATCH_PATH="${_PROJECT_PATH}/patch"

# echo "llvm/tools/clang/;${_PATCH_PATH}/bugfix000.patch"

# executeBuilder --help

# executeBuilder --checkout --patch --configure --build --clangVersion "${_CLANG_VERSION}" --patchApplyLocation "llvm/" --patchPath "${HOME}/.emacs.d/.emacs25/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch" --buildType "Debug" > llvm-build.log 2>&1

executeBuilder --checkout --patch --configure --build --clangVersion "${_CLANG_VERSION}" --patchInfo "llvm/tools/clang/;${_PATCH_PATH}/bugfix000.patch" --patchInfo "llvm/;${HOME}/.emacs.d/.emacs25/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch" > llvm-build.log 2>&1

# executeBuilder --checkout --patch --clangVersion "${_CLANG_VERSION}" --patchApplyLocation "llvm/" --patchPath "${HOME}/.emacs.d/.emacs25/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch" > llvm-build-prepare.log 2>&1
# executeBuilder --configure --build --clangVersion "${_CLANG_VERSION}" --buildType "Debug" --projectBuilder "cmake" > llvm-build-debug.log 2>&1
# executeBuilder --configure --build --clangVersion "${_CLANG_VERSION}" --buildType "Release" --projectBuilder "cmake" > llvm-build-release.log 2>&1

