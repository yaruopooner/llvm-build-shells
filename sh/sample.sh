# -*- mode: shell-script ; coding: utf-8-unix -*-
#! /bin/sh

. ./llvm-builder.sh

declare -r CLANG_VERSION="${1-390}"
declare -r PROJECT_PATH=$( cd $(dirname ${0}) && cd .. && pwd )
declare -r PATCH_PATH="${PROJECT_PATH}/patch"

# echo "llvm/tools/clang/;${PATCH_PATH}/bugfix000.patch"

# executeBuilder --help

# executeBuilder --checkout --patch --configure --build --clangVersion "${CLANG_VERSION}" --patchApplyLocation "llvm/" --patchPath "${HOME}/.emacs.d/.emacs25/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch" --buildType "Debug" > llvm-build.log 2>&1
# executeBuilder --checkout --patch --clangVersion "${CLANG_VERSION}" --patchInfo "llvm/tools/clang/;${PATCH_PATH}/bugfix000.patch" --patchInfo "llvm/;${HOME}/.emacs.d/.emacs25/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch" > llvm-build.log 2>&1
executeBuilder --checkout --patch --configure --build --clangVersion "${CLANG_VERSION}" --patchInfo "llvm/tools/clang/;${PATCH_PATH}/bugfix000.patch" --patchInfo "llvm/;${HOME}/.emacs.d/.emacs25/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch" > llvm-build.log 2>&1
# executeBuilder --checkout --patch --clangVersion "${CLANG_VERSION}" --patchApplyLocation "llvm/" --patchPath "${HOME}/.emacs.d/.emacs25/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch" > llvm-build-prepare.log 2>&1
# executeBuilder --configure --build --clangVersion "${CLANG_VERSION}" --buildType "Debug" --projectBuilder "cmake" > llvm-build-debug.log 2>&1
# executeBuilder --configure --build --clangVersion "${CLANG_VERSION}" --buildType "Release" --projectBuilder "cmake" > llvm-build-release.log 2>&1

