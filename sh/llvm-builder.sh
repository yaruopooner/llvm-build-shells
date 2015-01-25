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
    echo "----------svn checkout phase----------"

    local REPOSITORY_PATH=`generateRepositoryRelativePath ${1} ${2}`
    local CHECKOUT_DIR=`generateCheckoutRootDirectoryName ${1} ${2}`

    echo "repository partial path=${REPOSITORY_PATH}"
    echo "checkout root directory=${CHECKOUT_DIR}"

    if [ -d ${CHECKOUT_DIR} ]; then
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


function executePatchBySVN()
{
    local CHECKOUTED_DIR=${1}
    local PATCH_APPLY_LOCATION=${2}
    local PATCH_PATH=${3}

    echo "----------svn patch phase----------"
    echo "CHECKOUTED_DIR       : ${CHECKOUTED_DIR}"
    echo "PATCH_APPLY_LOCATION : ${PATCH_APPLY_LOCATION}"
    echo "PATCH_PATH           : ${PATCH_PATH}"
    pwd

    if [ ! -d ${CHECKOUTED_DIR} ]; then
        echo "not found checkout root directory"
        return 0
    fi

    pushd ${CHECKOUTED_DIR}
    pushd ${PATCH_APPLY_LOCATION}

    svn patch ${PATCH_PATH}

    popd
    popd

    return 1
}


function executeConfigure()
{
    echo "----------configure phase----------"
    local CHECKOUTED_DIR=${1}
    local BUILD_DIR=build

    echo "checkout root dir > ${CHECKOUTED_DIR}"

    if [ ! -d ${CHECKOUTED_DIR} ]; then
        echo "not found checkout root directory"
        return 0
    fi
    pushd ${CHECKOUTED_DIR}

    # if [ ! -d ${BUILD_DIR} ]; then
    #     # rm -rf ${BUILD_DIR}
    #     mkdir ${BUILD_DIR}
    # fi
    if [ -d ${BUILD_DIR} ]; then
        rm -rf ${BUILD_DIR}
    fi
    mkdir ${BUILD_DIR}
    pushd ${BUILD_DIR}


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

    popd
    popd
    
    return 1
}


function executeBuild()
{
    echo "----------build phase----------"

    local CHECKOUTED_DIR=${1}
    local BUILD_DIR=build

    pushd ${CHECKOUTED_DIR}
    pushd ${BUILD_DIR}

    make -j4

    popd
    popd

    return 1
}


function executeRebuild()
{
    local CLANG_VERSION=
    local CLANG_MINOR_VERSION=

    for OPT in $@
    do
        case $OPT in
            '-clangVersion' )
                CLANG_VERSION=${2}
                shift 2
                ;;
            '-clangMinorVersion' )
                CLANG_MINOR_VERSION=${2}
                shift 2
                ;;
        esac
    done

    local CHECKOUTED_DIR=`generateCheckoutRootDirectoryName ${CLANG_VERSION} ${CLANG_MINOR_VERSION}`
    local BUILD_DIR=build

    
    echo "checkout root dir > ${CHECKOUTED_DIR}"

    if [ ! -d ${CHECKOUTED_DIR} ]; then
        echo "not found checkout root directory"
        return 0
    fi
    cd ${CHECKOUTED_DIR}

    if [ ! -d ${BUILD_DIR} ]; then
        echo "not found build root directory"
        return 0
    fi
    cd ${BUILD_DIR}


    make clean

    local CCACHE_CMD=""

    if [ ${ENABLE_CCACHE} ]; then
	    CCACHE_CMD="ccache "
    fi

    CC_CMD="${CCACHE_CMD}gcc"
    CXX_CMD="${CCACHE_CMD}g++"
    CC=${CC_CMD} CXX=${CXX_CMD} ../llvm/configure --enable-optimized --enable-assertions=no --enable-targets=host-only

    make -j4

    return 1
}


function executeBuilder()
{
    local TASK_CHECKOUT=
    local TASK_PATCH=
    local TASK_CONFIGURE=
    local TASK_BUILD=
    local CLANG_VERSION=
    local CLANG_MINOR_VERSION=
    local PATCH_APPLY_LOCATIONS=()
    local PATCH_PATHS=()

    for OPT in $@
    do
        case $OPT in
            '-checkout' )
                TASK_CHECKOUT=true
                shift
                ;;
            '-patch' )
                TASK_PATCH=true
                shift
                ;;
            '-configure' )
                TASK_CONFIGURE=true
                shift
                ;;
            '-build' )
                TASK_BUILD=true
                shift
                ;;
            '-clangVersion' )
                CLANG_VERSION=${2}
                shift 2
                ;;
            '-clangMinorVersion' )
                CLANG_MINOR_VERSION=${2}
                shift 2
                ;;
            '-patchApplyLocation' )
                PATCH_APPLY_LOCATIONS+=(${2})
                shift 2
                ;;
            '-patchPath' )
                PATCH_PATHS+=(${2})
                shift 2
                ;;
        esac
    done


    local CHECKOUTED_DIR=`generateCheckoutRootDirectoryName ${CLANG_VERSION} ${CLANG_MINOR_VERSION}`


    if [ ${TASK_CHECKOUT} ]; then
       executeCheckoutBySVN ${CLANG_VERSION} ${CLANG_MINOR_VERSION}
    fi

    if [ ${TASK_PATCH} ]; then
       if [ ${#PATCH_PATHS[@]} -eq ${#PATCH_APPLY_LOCATIONS[@]} ]; then
           for ((i = 0; i < ${#PATCH_PATHS[@]}; ++i))
           do
               executePatchBySVN ${CHECKOUTED_DIR} ${PATCH_APPLY_LOCATIONS[$i]} ${PATCH_PATHS[$i]}
           done
       fi
    fi

    if [ ${TASK_CONFIGURE} ]; then
       executeConfigure ${CHECKOUTED_DIR}
    fi

    if [ ${TASK_BUILD} ]; then
       executeBuild ${CHECKOUTED_DIR}
    fi
}



