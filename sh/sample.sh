# -*- mode: shell-script ; coding: utf-8-unix -*-
#! /bin/sh

. ./llvm-builder.sh

# executeRebuild -clangVersion 350 > llvm-build.log 2>&1

# executeBuilder -clangVersion 350 > llvm-build.log 2>&1
# executeBuilder -clangVersion 350 -patchApplyLocation "llvm/" -patchPath "~/work/ac-clang/clang-server/patch/invalid-mmap.svn-patch"  -patchApplyLocation "llvm/clang/" -patchPath "~/work/ac-clang/clang-server/patch/libclang-x86_64.svn-patch" > llvm-build.log 2>&1
# executeBuilder -checkout -patch -configure -build -clangVersion 350 -patchApplyLocation "llvm/" -patchPath "/home/yaruopooner/work/ac-clang/clang-server/patch/invalid-mmap.svn-patch"  -patchApplyLocation "llvm/tools/clang/" -patchPath "/home/yaruopooner/work/ac-clang/clang-server/patch/libclang-x86_64.svn-patch" > llvm-build.log 2>&1
executeBuilder -checkout -patch -configure -clangVersion 350 -patchApplyLocation "llvm/" -patchPath "/home/yaruopooner/work/ac-clang/clang-server/patch/invalid-mmap.svn-patch"  -patchApplyLocation "llvm/tools/clang/" -patchPath "/home/yaruopooner/work/ac-clang/clang-server/patch/libclang-x86_64.svn-patch" > llvm-build.log 2>&1

