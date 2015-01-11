# -*- mode: shell-script ; coding: utf-8-unix -*-
#! /bin/sh

# build passed : 1.7.34(0.282/5/3) 2014-12-17 13:43 x86_64 Cygwin

# $1 は 31 32 33 34 350 という書式で指定
# $2 は 1 2 3 という書式で指定
# $1 未指定の場合は trunk がバインドされる
# チェックアウト先に同名ディレクトリがある場合は削除して作成するので注意


function generateRepositoryRelativePath()
{
    local MAJOR_VERSION=trunk
    local MINOR_VERSION=""
    local REPOSITORY_PATH=${MAJOR_VERSION}

    if [ ${1} ]; then
        MAJOR_VERSION=${1}
        if [ ${2} ]; then
            MINOR_VERSION="dot${2}-"
        fi
        REPOSITORY_PATH=tags/RELEASE_${MAJOR_VERSION}/${MINOR_VERSION}final
    fi

    echo "${REPOSITORY_PATH}"
}

function generateCheckoutRootDirectoryName()
{
    local MAJOR_VERSION=trunk
    local MINOR_VERSION=""

    if [ ${1} ]; then
        MAJOR_VERSION=${1}
        if [ ${2} ]; then
            MINOR_VERSION="dot${2}-"
        fi
    fi

    echo "clang-${MAJOR_VERSION}${MINOR_VERSION}"
}

function executeCheckoutBySVN()
{
    local REPOSITORY_PATH=`generateRepositoryRelativePath ${1} ${2}`
    local CHECKOUT_DIR=`generateCheckoutRootDirectoryName ${1} ${2}`

    echo "repository partial path=${REPOSITORY_PATH}"
    echo "checkout root directory=${CHECKOUT_DIR}"

    if [ -d ${CHECKOUT_DIR} ] ; then
        echo "remove old root directory ${CHECKOUT_DIR}"
        rm -rf ${CHECKOUT_DIR}
    fi
    mkdir ${CHECKOUT_DIR}
    pushd ${CHECKOUT_DIR}

    # proxy がある場合は ~/.subversion/servers に host と port を指定

    svn co http://llvm.org/svn/llvm-project/llvm/${REPOSITORY_PATH} llvm
    pushd llvm/tools
    svn co http://llvm.org/svn/llvm-project/cfe/${REPOSITORY_PATH} clang
    popd
    pushd llvm/tools/clang/tools
    svn co http://llvm.org/svn/llvm-project/clang-tools-extra/${REPOSITORY_PATH} extra
    popd
    pushd llvm/projects
    svn co http://llvm.org/svn/llvm-project/compiler-rt/${REPOSITORY_PATH} compiler-rt
    popd

    popd

    echo "${CHECKOUT_DIR}"
}

function executeBuild()
{
    local CHECKOUTED_DIR=${1}
    local BUILD_DIR=build

    echo "checkout root dir > ${CHECKOUTED_DIR}"

    if [ ! -d ${CHECKOUTED_DIR} ] ; then
        echo "not found checkout root dir"
        return 0
    fi
    cd ${CHECKOUTED_DIR}

    # if [ ! -d ${BUILD_DIR} ] ; then
    #     # rm -rf ${BUILD_DIR}
    #     mkdir ${BUILD_DIR}
    # fi
    if [ -d ${BUILD_DIR} ] ; then
        rm -rf ${BUILD_DIR}
        mkdir ${BUILD_DIR}
    fi
    cd ${BUILD_DIR}


    local CCACHE_CMD=""

    if [ ${ENABLE_CCACHE} ]; then
	    CCACHE_CMD="ccache "
    fi

    CC_CMD="${CCACHE_CMD}gcc"
    CXX_CMD="${CCACHE_CMD}g++"

    # CC と CXX を指定しないと何故かコケる
    # CC=gcc CXX=g++ ../llvm/configure --enable-optimized --disable-docs --prefix=/opt/ll
    CC=${CC_CMD} CXX=${CXX_CMD} ../llvm/configure --enable-optimized --enable-assertions=no --enable-targets=host-only
    # CC=${CC_CMD} CXX=${CXX_CMD} ../llvm/configure --enable-optimized --enable-assertions=no --enable-targets=x86,x86_64,cpp

    # CC と CXX を指定しないと何故かコケる
    # CC=gcc CXX=g++ ../llvm/configure --enable-optimized --disable-docs --prefix=/opt/ll
    # CC=${CC_CMD} CXX=${CXX_CMD} ../llvm/configure --enable-optimized --enable-assertions=no --enable-targets=host-only
    # CC=${CC_CMD} CXX=${CXX_CMD} ../llvm/configure --enable-optimized --enable-assertions=no --enable-targets=host-only


    make -j4

    return 1
}


function executeCheckoutAndBuild()
{
    local CHECKOUTED_DIR=`generateCheckoutRootDirectoryName ${1} ${2}`
    
    executeCheckoutBySVN ${1} ${2}
    executeBuild ${CHECKOUTED_DIR}
}


