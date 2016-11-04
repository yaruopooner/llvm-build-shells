# -*- mode: shell-script ; coding: utf-8-unix -*-
#! /bin/sh

. ./llvm-builder.sh

readonly PROJECT_PATH=$( cd $(dirname ${0}) && cd .. && pwd )
readonly PATCHS_PATH="${PROJECT_PATH}/patch"

# echo "llvm/tools/clang/;${PATCHS_PATH}/bugfix000.patch"

# executeBuilder --help

# executeBuilder --checkout --patch --configure --build --clangVersion 390 --patchApplyLocation "llvm/" --patchPath "/home/yaruopooner/.emacs.d/.emacs25/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch" --buildType "Debug" > llvm-build.log 2>&1
# executeBuilder --checkout --patch --clangVersion 390 --patchApplyLocation "llvm/" --patchPath "/home/yaruopooner/.emacs.d/.emacs25/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch" > llvm-build-prepare.log 2>&1
# executeBuilder --checkout --patch --clangVersion 390 --patchApplyLocation "llvm/" --patchPath "/home/yaruopooner/.emacs.d/.emacs25/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch" > llvm-build-prepare.log 2>&1
# executeBuilder --checkout --patch --clangVersion 390 --patchInfo "llvm/tools/clang/;${PATCHS_PATH}/bugfix000.patch" --patchInfo "llvm/;/home/test/.emacs.d/.emacs25/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch" > llvm-build.log 2>&1
executeBuilder --checkout --patch --configure --build --clangVersion 390 --patchInfo "llvm/tools/clang/;${PATCHS_PATH}/bugfix000.patch" --patchInfo "llvm/;/home/test/.emacs.d/.emacs25/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch" > llvm-build.log 2>&1
# executeBuilder --checkout --patch --clangVersion 390 --patchApplyLocation "llvm/" --patchPath "/home/yaruopooner/.emacs.d/.emacs25/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch" > llvm-build-prepare.log 2>&1
# executeBuilder --configure --build --clangVersion 390 --buildType "Debug" --projectBuilder "cmake" > llvm-build-debug.log 2>&1
# executeBuilder --configure --build --clangVersion 390 --buildType "Release" --projectBuilder "cmake" > llvm-build-release.log 2>&1
# executeBuilder --patch --build --clangVersion 390 --patchApplyLocation "llvm/" --patchPath "/home/yaruopooner/.emacs.d/.emacs25/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch" --buildType "Debug" > llvm-build.log 2>&1
# executeBuilder --checkout --patch --configure --clangVersion 390 --patchApplyLocation "llvm/" --patchPath "/home/yaruopooner/work/ac-clang/clang-server/patch/invalidate-mmap.patch" > llvm-build.log 2>&1

