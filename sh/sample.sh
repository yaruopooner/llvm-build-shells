# -*- mode: shell-script ; coding: utf-8-unix -*-
#! /bin/sh

. ./llvm-builder.sh


# executeBuilder --checkout --patch --configure --build --clangVersion 380 --patchApplyLocation "llvm/" --patchPath "/home/yaruopooner/.emacs.d/.emacs24/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch" --buildType "Debug" > llvm-build.log 2>&1
executeBuilder --checkout --patch --clangVersion 380 --patchApplyLocation "llvm/" --patchPath "/home/yaruopooner/.emacs.d/.emacs24/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch" > llvm-build-prepare.log 2>&1
executeBuilder --configure --build --clangVersion 380 --buildType "Debug" --projectBuilder "cmake" > llvm-build-debug.log 2>&1
executeBuilder --configure --build --clangVersion 380 --buildType "Release" --projectBuilder "cmake" > llvm-build-release.log 2>&1
# executeBuilder --patch --build --clangVersion 380 --patchApplyLocation "llvm/" --patchPath "/home/yaruopooner/.emacs.d/.emacs24/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch" --buildType "Debug" > llvm-build.log 2>&1
# executeBuilder --checkout --patch --configure --clangVersion 380 --patchApplyLocation "llvm/" --patchPath "/home/yaruopooner/work/ac-clang/clang-server/patch/invalidate-mmap.patch" > llvm-build.log 2>&1

