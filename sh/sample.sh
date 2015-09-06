# -*- mode: shell-script ; coding: utf-8-unix -*-
#! /bin/sh

. ./llvm-builder.sh


executeBuilder --checkout --patch --configure --build --clangVersion 370 --patchApplyLocation "llvm/" --patchPath "/home/yaruopooner/work/ac-clang/clang-server/patch/invalidate-mmap.patch" > llvm-build.log 2>&1
# executeBuilder --checkout --patch --configure --clangVersion 370 --patchApplyLocation "llvm/" --patchPath "/home/yaruopooner/work/ac-clang/clang-server/patch/invalidate-mmap.patch" > llvm-build.log 2>&1

