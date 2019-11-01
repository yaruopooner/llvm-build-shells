# -*- mode: shell-script ; coding: utf-8-unix -*-
#! /bin/sh

# build passed : 1.7.34(0.282/5/3) 2014-12-17 13:43 x86_64 Cygwin

# $1 は 31 32 33 34 350 という書式で指定
# $2 は 1 2 3 という書式で指定
# $1 未指定の場合は trunk がバインドされる
# チェックアウト先に同名ディレクトリがある場合は削除して作成するので注意

function usage()
{
    echo 'Usage: executeBuilder [OPTIONS]'
    echo
    echo 'Options:'
    echo ' --checkout'
    echo '     checkout LLVM by GIT'
    echo '     validate option > --llvmVersion'
    echo ' --patch'
    echo '     apply patch by GIT'
    echo '     The patch file path is referenced from "llvm.git.options"'
    echo ' --configure'
    echo '     generate Makefile'
    echo ' --build'
    echo '     execute make'
    echo ' --llvmCheckoutTag "CHECKOUT_TAG_NAME"'
    echo '     LLVM checkout tag name'
    echo '     default is leatest version tag'
    echo ' --buildType "[Release|Debug]"'
    echo '     default is Release'
    echo ' --projectBuilder "[make|cmake]"'
    echo '     default is cmake'
    echo ' --help'
}


function get_command_version()
{
    local -r COMMAND="${1}"
    local -r RESULT=$( echo `${COMMAND} --version` )
    local -r REGEX_PATTERN='^.*([0-9]+\.[0-9]+\.[0-9]+).*$'
    local -r VERSION=$( echo "${RESULT}" | sed -r "s/${REGEX_PATTERN}/\1/" )

    echo "${VERSION}"
}

function is_valid_version()
{
    local -r COMMAND="${1}"
    local -r REGEX_PATTERN='^.*([0-9]+)\.([0-9]+)\.([0-9]+).*$'
    local -r VERSION=$( get_command_version "${COMMAND}" )
    local -r MAJAR=$( echo "${VERSION}" | sed -r "s/${REGEX_PATTERN}/\1/" )
    local -r MINOR=$( echo "${VERSION}" | sed -r "s/${REGEX_PATTERN}/\2/" )
    local -r MAINTENANCE=$( echo "${VERSION}" | sed -r "s/${REGEX_PATTERN}/\3/" )
    local -r REQUIRE_VERSION="${2}"
    local -r REQUIRE_MAJAR=$( echo "${REQUIRE_VERSION}" | sed -r "s/${REGEX_PATTERN}/\1/" )
    local -r REQUIRE_MINOR=$( echo "${REQUIRE_VERSION}" | sed -r "s/${REGEX_PATTERN}/\2/" )
    local -r REQUIRE_MAINTENANCE=$( echo "${REQUIRE_VERSION}" | sed -r "s/${REGEX_PATTERN}/\3/" )

    if $( [ ${MAJAR} -gt ${REQUIRE_MAJAR} ] || $( [ ${MAJAR} -eq ${REQUIRE_MAJAR} ] && $( [ ${MINOR} -gt ${REQUIRE_MINOR} ] || $( [ ${MINOR} -eq ${REQUIRE_MINOR} ] && [ ${MAINTENANCE} -ge ${REQUIRE_MAINTENANCE} ] ) ) ) ); then
        # valid
        return 0
    else
        # invalid
        return 1
    fi
}


declare -r LLVM_GIT_INFOS_FILE="llvm-git.options"
declare -r LLVM_GIT_INFOS_SRC_FILE="${LLVM_GIT_INFOS_FILE}.sample"

function loadVariablesOnOptionFile()
{
    local -r OPTION_FILE_PATH=${1}
    local -r ORIGINAL_OPTION_FILE_PATH=${2}

    cp -up "./${ORIGINAL_OPTION_FILE_PATH}" "./${OPTION_FILE_PATH}"

    # overwrite vars load
    if [ -e "./${OPTION_FILE_PATH}" ]; then
        . "./${OPTION_FILE_PATH}"
    fi
}

function loadGITRepositoryInfos()
{
    loadVariablesOnOptionFile "${LLVM_GIT_INFOS_FILE}" "${LLVM_GIT_INFOS_SRC_FILE}"
}


function executeCheckoutByGIT()
{
    echo "----------git checkout phase----------"

    loadGITRepositoryInfos

    local -r REPOSITORY_NAME="${GitCheckoutInfos[RepositoryName]}"
    local -r REPOSITORY_URL="${GitCheckoutInfos[RepositoryURL]}"
    local -r DEFAULT_CHECKOUT_TAG="${GitCheckoutInfos[DefaultCheckoutTag]}"
    local -r FETCH="${GitCheckoutInfos[Fetch]}"
    local -rn ADDITIONAL_OPTIONS="${GitCheckoutInfos[AdditionalOptions]}"

    local CHECKOUT_TAG=${DEFAULT_CHECKOUT_TAG}

    # checkout tag
    if [ ${1} ]; then
        CHECKOUT_TAG=${1}
    fi


    if [ -d ${REPOSITORY_NAME} ]; then
        if ${FETCH}; then
            pushd ${REPOSITORY_NAME}

            echo "====fetch===="

            git fetch
            git fetch --tags

            popd
        fi
    else
        local -r CMD_ARGS=("clone" "${REPOSITORY_URL}" "${ADDITIONAL_OPTIONS}")

        echo "====clone detail===="
        echo "repository   : ${REPOSITORY_NAME}"
        echo "url          : ${REPOSITORY_URL}"
        echo "command      : git ${CMD_ARGS[@]}"

        git ${CMD_ARGS[@]}
    fi

    if [ -d ${REPOSITORY_NAME} ]; then
        pushd ${REPOSITORY_NAME}

        # branch clean
        git clean -df

        # branch checkout
        local -r START_POINT="refs/tags/${CHECKOUT_TAG}"
        local -r BRANCH=${CHECKOUT_TAG}
        local -r CMD_ARGS=("checkout" "--force" "-B" "${BRANCH}" "${START_POINT}")

        echo "====checkout branch===="
        echo "checkout tag : ${CHECKOUT_TAG}"
        echo "command      : git ${CMD_ARGS[@]}"

        git ${CMD_ARGS[@]}

        popd
    fi
}


function executePatchByGIT()
{
    local -r REPOSITORY_DIR=${1}
    local -r PATCH_PATH=${2}
    local -r CMD_ARGS=("apply" "${PATCH_PATH}")
    # local -r CMD_ARGS=("apply" "--check" "${PATCH_PATH}")

    echo "----------git patch phase----------"
    echo "repository_dir       : ${REPOSITORY_DIR}"
    echo "patch_path           : ${PATCH_PATH}"
    echo "command              : git ${CMD_ARGS[@]}"
    pwd

    if [ ! -d ${REPOSITORY_DIR} ]; then
        echo "not found repository directory"
        return 1
    fi

    pushd ${REPOSITORY_DIR}

    git ${CMD_ARGS[@]}

    popd

    return 0
}


function executeConfigure()
{
    echo "----------configure phase----------"
    local -r CHECKOUTED_DIR="${1}"
    local -r BUILD_TYPE="${2}"
    local -r BUILD_DIR="build-${BUILD_TYPE}"

    echo "checkout root dir > ${CHECKOUTED_DIR}"
    echo "build type        > ${BUILD_TYPE}"

    if [ ! -d ${CHECKOUTED_DIR} ]; then
        echo "not found checkout root directory"
        return 1
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
    # CC=${CC_CMD} CXX=${CXX_CMD} ../llvm/configure --enable-optimized --enable-assertions=no --enable-targets=host-only
    # CC=${CC_CMD} CXX=${CXX_CMD} ../llvm/configure --enable-optimized --enable-assertions=no --enable-targets=x86,x86_64,cpp

    # release options
    local OPTIONS="--enable-optimized --enable-assertions=no --enable-targets=host-only"

    if [ ${BUILD_TYPE} = "Debug" ]; then
        OPTIONS="--disable-optimized --enable-assertions --enable-debug-runtime --enable-debug-symbols --enable-targets=host-only"
    fi

    CC=${CC_CMD} CXX=${CXX_CMD} ../llvm/configure ${OPTIONS}
    
    # CC と CXX を指定しないと何故かコケる
    # CC=gcc CXX=g++ ../llvm/configure --enable-optimized --disable-docs --prefix=/opt/ll
    # CC=${CC_CMD} CXX=${CXX_CMD} ../llvm/configure --enable-optimized --enable-assertions=no --enable-targets=host-only
    # CC=${CC_CMD} CXX=${CXX_CMD} ../llvm/configure --enable-optimized --enable-assertions=no --enable-targets=host-only

    popd
    popd
    
    return 0
}


function executeConfigureByCMake()
{
    echo "----------configure by cmake phase----------"
    local -r CHECKOUTED_DIR="${1}"
    local -r BUILD_TYPE="${2}"
    local -r BUILD_DIR="build-${BUILD_TYPE}"
    local -r REQUIRE_VERSION="3.4.3"
    
    if ! is_valid_version "cmake" "${REQUIRE_VERSION}"; then
        echo "cmake not enough version"
        echo "current cmake version "$( get_command_version "cmake" )
        echo "require version ${REQUIRE_VERSION} or higher version"
        return 1
    fi

    echo "checkout root dir > ${CHECKOUTED_DIR}"
    echo "build type        > ${BUILD_TYPE}"

    if [ ! -d ${CHECKOUTED_DIR} ]; then
        echo "not found checkout root directory"
        return 2
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

    cmake ../llvm -DCMAKE_BUILD_TYPE=${BUILD_TYPE}

    popd
    popd

    return 0
}


function executeBuild()
{
    echo "----------build phase----------"

    local -r CHECKOUTED_DIR="${1}"
    local -r BUILD_TYPE="${2}"
    local -r BUILD_DIR="build-${BUILD_TYPE}"

    pushd ${CHECKOUTED_DIR}
    pushd ${BUILD_DIR}

    make -j4

    popd
    popd

    return 0
}


function executeBuildByCMake()
{
    echo "----------build by cmake phase----------"

    local -r CHECKOUTED_DIR="${1}"
    local -r BUILD_TYPE="${2}"
    local -r BUILD_DIR="build-${BUILD_TYPE}"

    pushd ${CHECKOUTED_DIR}
    pushd ${BUILD_DIR}

    cmake --build .

    popd
    popd

    return 0
}


function executeRebuild()
{
    local LLVM_VERSION=
    local LLVM_MINOR_VERSION=
    local OPT

    for OPT in $@
    do
        case $OPT in
            '-llvmMinorVersion' )
                LLVM_MINOR_VERSION=${2}
                shift 2
                ;;
        esac
    done

    local -r CHECKOUTED_DIR=`generateCheckoutRootDirectoryName ${LLVM_VERSION} ${LLVM_MINOR_VERSION}`
    local -r BUILD_DIR="build"

    
    echo "checkout root dir > ${CHECKOUTED_DIR}"

    if [ ! -d ${CHECKOUTED_DIR} ]; then
        echo "not found checkout root directory"
        return 1
    fi
    cd ${CHECKOUTED_DIR}

    if [ ! -d ${BUILD_DIR} ]; then
        echo "not found build root directory"
        return 1
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

    return 0
}


function executeBuilder()
{
    local TASK_CHECKOUT=
    local TASK_PATCH=
    local TASK_CONFIGURE=
    local TASK_BUILD=
    local LLVM_CHECKOUT_TAG=
    local BUILD_TYPE="Release"
    local PROJECT_BUILDER="cmake"

    for OPT in $@
    do
        case $OPT in
            '--checkout' )
                TASK_CHECKOUT=true
                shift
                ;;
            '--patch' )
                TASK_PATCH=true
                shift
                ;;
            '--configure' )
                TASK_CONFIGURE=true
                shift
                ;;
            '--build' )
                TASK_BUILD=true
                shift
                ;;
            '--buildType' )
                BUILD_TYPE=${2}
                shift 2
                ;;
            '--llvmCheckoutTag' )
                LLVM_CHECKOUT_TAG=${2}
                shift 2
                ;;
            '--projectBuilder' )
                PROJECT_BUILDER=${2}
                shift 2
                ;;
            '--help' )
                usage
                exit 1
                ;;
        esac
    done


    local -r CHECKOUTED_DIR="."


    if [ ${TASK_CHECKOUT} ]; then
       executeCheckoutByGIT ${LLVM_CHECKOUT_TAG}

       if [ $? -ne 0 ]; then
           echo "abort executeCheckoutByGIT"
           exit 1
       fi
    fi
    
    if [ ${TASK_PATCH} ]; then
        local -r REPOSITORY_NAME="${GitCheckoutInfos[RepositoryName]}"
        local -rn PATCHES="${GitCheckoutInfos[Patches]}"

        for PATCH_PATH in "${PATCHES[@]}"; do
            executePatchByGIT ${REPOSITORY_NAME} ${PATCH_PATH}

            if [ $? -ne 0 ]; then
                echo "abort executePatchByGIT"
                exit 1
            fi
        done
    fi

    if [ ${TASK_CONFIGURE} ]; then
        case ${PROJECT_BUILDER} in
            'make' )
                executeConfigure ${CHECKOUTED_DIR} ${BUILD_TYPE}

                if [ $? -ne 0 ]; then
                    echo "abort executeConfigure"
                    exit 1
                fi
                ;;
            'cmake' )
                executeConfigureByCMake ${CHECKOUTED_DIR} ${BUILD_TYPE}

                if [ $? -ne 0 ]; then
                    echo "abort executeConfigureByCMake"
                    exit 1
                fi
                ;;
        esac
    fi

    if [ ${TASK_BUILD} ]; then
        case ${PROJECT_BUILDER} in
            'make' )
                executeBuild ${CHECKOUTED_DIR} ${BUILD_TYPE}

                if [ $? -ne 0 ]; then
                    echo "abort executeBuild"
                    exit 1
                fi
                ;;
            'cmake' )
                executeBuildByCMake ${CHECKOUTED_DIR} ${BUILD_TYPE}

                if [ $? -ne 0 ]; then
                    echo "abort executeBuildByCMake"
                    exit 1
                fi
                ;;
        esac
    fi
}



