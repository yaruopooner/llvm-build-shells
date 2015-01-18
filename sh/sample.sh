# -*- mode: shell-script ; coding: utf-8-unix -*-
#! /bin/sh

. ./llvm-builder.sh

executeCheckoutAndBuild 350 > llvm-build.log 2>&1
# executeRebuild 350 > llvm-build.log 2>&1
