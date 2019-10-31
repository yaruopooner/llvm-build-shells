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
    echo '     checkout LLVM by SVN'
    echo '     validate option > --llvmVersion'
    echo ' --patch'
    echo '     apply patch by SVN'
    echo '     validate option > --patchApplyLocation, --patchPath, --patchInfo'
    echo ' --configure'
    echo '     generate Makefile'
    echo ' --build'
    echo '     execute make'
    echo ' --llvmVersion [VersionNumber]'
    echo '     LLVM checkout version'
    echo '     default is trunk'
    echo ' --llvmCheckoutTag "CHECKOUT_TAG_NAME"'
    echo '     LLVM checkout tag name'
    echo '     default is leatest version tag'
    echo ' --patchApplyLocation "APPLY_LOCATION"'
    echo '     patch apply target relative directory from checkout directory'
    echo '     example : llvm/, llvm/tools/clang/'
    echo ' --patchPath "PATH"'
    echo '     patch file path'
    echo ' --patchInfo "APPLY_LOCATION;PATH"'
    echo '     patch apply target directory and patch file path'
    echo ' --buildType "[Release|Debug]"'
    echo '     default is Release'
    echo ' --projectBuilder "[make|cmake]"'
    echo '     default is cmake'
    echo ' --help'
}


function get_command_version()
{
    local readonly COMMAND="${1}"
    local readonly RESULT=$( echo `${COMMAND} --version` )
    local readonly REGEX_PATTERN='^.*([0-9]+\.[0-9]+\.[0-9]+).*$'
    local readonly VERSION=$( echo "${RESULT}" | sed -r "s/${REGEX_PATTERN}/\1/" )

    echo "${VERSION}"
}

function is_valid_version()
{
    local readonly COMMAND="${1}"
    local readonly REGEX_PATTERN='^.*([0-9]+)\.([0-9]+)\.([0-9]+).*$'
    local readonly VERSION=$( get_command_version "${COMMAND}" )
    local readonly MAJAR=$( echo "${VERSION}" | sed -r "s/${REGEX_PATTERN}/\1/" )
    local readonly MINOR=$( echo "${VERSION}" | sed -r "s/${REGEX_PATTERN}/\2/" )
    local readonly MAINTENANCE=$( echo "${VERSION}" | sed -r "s/${REGEX_PATTERN}/\3/" )
    local readonly REQUIRE_VERSION="${2}"
    local readonly REQUIRE_MAJAR=$( echo "${REQUIRE_VERSION}" | sed -r "s/${REGEX_PATTERN}/\1/" )
    local readonly REQUIRE_MINOR=$( echo "${REQUIRE_VERSION}" | sed -r "s/${REGEX_PATTERN}/\2/" )
    local readonly REQUIRE_MAINTENANCE=$( echo "${REQUIRE_VERSION}" | sed -r "s/${REGEX_PATTERN}/\3/" )

    if $( [ ${MAJAR} -gt ${REQUIRE_MAJAR} ] || $( [ ${MAJAR} -eq ${REQUIRE_MAJAR} ] && $( [ ${MINOR} -gt ${REQUIRE_MINOR} ] || $( [ ${MINOR} -eq ${REQUIRE_MINOR} ] && [ ${MAINTENANCE} -ge ${REQUIRE_MAINTENANCE} ] ) ) ) ); then
        # valid
        return 0
    else
        # invalid
        return 1
    fi
}


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
        REPOSITORY_PATH="tags/RELEASE_${MAJOR_VERSION}/${MINOR_VERSION}final"
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

    echo "llvm-${MAJOR_VERSION}${MINOR_VERSION}"
}


declare -r LLVM_SVN_INFOS_FILE="llvm-svn.options"
declare -r LLVM_SVN_INFOS_SRC_FILE="${LLVM_SVN_INFOS_FILE}.sample"
declare -r LLVM_GIT_INFOS_FILE="llvm-git.options"
declare -r LLVM_GIT_INFOS_SRC_FILE="${LLVM_GIT_INFOS_FILE}.sample"

function loadVariablesOnOptionFile()
{
    local readonly OPTION_FILE_PATH=${1}
    local readonly ORIGINAL_OPTION_FILE_PATH=${2}

    cp -up "./${ORIGINAL_OPTION_FILE_PATH}" "./${OPTION_FILE_PATH}"

    # overwrite vars load
    if [ -e "./${OPTION_FILE_PATH}" ]; then
        . "./${OPTION_FILE_PATH}"
    fi
}

function loadSVNRepositoryInfos()
{
    cp -up "./${LLVM_SVN_INFOS_SRC_FILE}" "./${LLVM_SVN_INFOS_FILE}"

    # overwrite vars load
    if [ -e "./${LLVM_SVN_INFOS_FILE}" ]; then
        . "./${LLVM_SVN_INFOS_FILE}"
    fi
}

function loadGITRepositoryInfos()
{
    loadVariablesOnOptionFile "${LLVM_GIT_INFOS_FILE}" "${LLVM_GIT_INFOS_SRC_FILE}"
}

function executeCheckoutBySVN()
{
    echo "----------svn checkout phase----------"

    loadSVNRepositoryInfos

    local readonly REPOSITORY_RPATH=`generateRepositoryRelativePath ${1} ${2}`
    local readonly CO_ROOT_DIR=`generateCheckoutRootDirectoryName ${1} ${2}`

    echo "repository partial path=${REPOSITORY_RPATH}"
    echo "checkout root directory=${CO_ROOT_DIR}"

    if [ -d ${CO_ROOT_DIR} ]; then
        echo "remove old root directory ${CO_ROOT_DIR}"
        rm -rf ${CO_ROOT_DIR}
    fi
    mkdir ${CO_ROOT_DIR}
    pushd ${CO_ROOT_DIR}

    # proxy がある場合は ~/.subversion/servers に host と port を指定

    local CO_INFO

    for CO_INFO in ${SvnCheckoutInfos[@]}; do
        eval local CO_LOCATION="\${${CO_INFO}[location]}"
        eval local CO_URL="\${${CO_INFO}[repository_url]}"
        eval local CO_DIR="\${${CO_INFO}[checkout_dir]}"

        echo "====checkout detail===="
        echo "location     : ${CO_LOCATION}"
        echo "url          : ${CO_URL}"
        echo "checkout dir : ${CO_DIR}"
        echo "command      : svn co ${CO_URL}${REPOSITORY_RPATH} ${CO_DIR}"

        pushd "${CO_LOCATION}"
        svn co "${CO_URL}${REPOSITORY_RPATH}" "${CO_DIR}"
        popd
    done

    popd

    echo "${CO_ROOT_DIR}"
}


function executeCheckoutByGIT()
{
    echo "----------git checkout phase----------"

    loadGITRepositoryInfos

    local readonly REPOSITORY_NAME="${GitCheckoutInfos[RepositoryName]}"
    local readonly REPOSITORY_URL="${GitCheckoutInfos[RepositoryURL]}"
    local readonly DEFAULT_CHECKOUT_TAG="${GitCheckoutInfos[DefaultCheckoutTag]}"
    local readonly FETCH="${GitCheckoutInfos[Fetch]}"
    eval local ADDITIONAL_OPTIONS="\${${GitCheckoutInfos[AdditionalOptions]}}"

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
        local readonly CMD_ARGS=("clone" "${REPOSITORY_URL}" "${ADDITIONAL_OPTIONS}")

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
        local readonly START_POINT="refs/tags/${CHECKOUT_TAG}"
        local readonly BRANCH=${CHECKOUT_TAG}
        local readonly CMD_ARGS=("checkout" "--force" "-B" "${BRANCH}" "${START_POINT}")

        echo "====checkout branch===="
        echo "checkout tag : ${CHECKOUT_TAG}"
        echo "command      : git ${CMD_ARGS[@]}"

        git ${CMD_ARGS[@]}

        popd
    fi
}


function executePatchBySVN()
{
    local readonly CHECKOUTED_DIR=${1}
    local readonly PATCH_APPLY_LOCATION=${2}
    local readonly PATCH_PATH=${3}

    echo "----------svn patch phase----------"
    echo "CHECKOUTED_DIR       : ${CHECKOUTED_DIR}"
    echo "PATCH_APPLY_LOCATION : ${PATCH_APPLY_LOCATION}"
    echo "PATCH_PATH           : ${PATCH_PATH}"
    pwd

    if [ ! -d ${CHECKOUTED_DIR} ]; then
        echo "not found checkout root directory"
        return 1
    fi

    pushd ${CHECKOUTED_DIR}
    pushd ${PATCH_APPLY_LOCATION}

    svn patch ${PATCH_PATH}

    popd
    popd

    return 0
}


function executePatchByGIT()
{
    local readonly CHECKOUTED_DIR=${1}
    local readonly PATCH_APPLY_LOCATION=${2}
    local readonly PATCH_PATH=${3}

    echo "----------svn patch phase----------"
    echo "CHECKOUTED_DIR       : ${CHECKOUTED_DIR}"
    echo "PATCH_APPLY_LOCATION : ${PATCH_APPLY_LOCATION}"
    echo "PATCH_PATH           : ${PATCH_PATH}"
    pwd

    if [ ! -d ${CHECKOUTED_DIR} ]; then
        echo "not found checkout root directory"
        return 1
    fi

    pushd ${CHECKOUTED_DIR}
    pushd ${PATCH_APPLY_LOCATION}

    svn patch ${PATCH_PATH}

    popd
    popd

    return 0
}


function executeConfigure()
{
    echo "----------configure phase----------"
    local readonly CHECKOUTED_DIR="${1}"
    local readonly BUILD_TYPE="${2}"
    local readonly BUILD_DIR="build-${BUILD_TYPE}"

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
    local readonly CHECKOUTED_DIR="${1}"
    local readonly BUILD_TYPE="${2}"
    local readonly BUILD_DIR="build-${BUILD_TYPE}"
    local readonly REQUIRE_VERSION="3.4.3"
    
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

    local readonly CHECKOUTED_DIR="${1}"
    local readonly BUILD_TYPE="${2}"
    local readonly BUILD_DIR="build-${BUILD_TYPE}"

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

    local readonly CHECKOUTED_DIR="${1}"
    local readonly BUILD_TYPE="${2}"
    local readonly BUILD_DIR="build-${BUILD_TYPE}"

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
            '-llvmVersion' )
                LLVM_VERSION=${2}
                shift 2
                ;;
            '-llvmMinorVersion' )
                LLVM_MINOR_VERSION=${2}
                shift 2
                ;;
        esac
    done

    local readonly CHECKOUTED_DIR=`generateCheckoutRootDirectoryName ${LLVM_VERSION} ${LLVM_MINOR_VERSION}`
    local readonly BUILD_DIR="build"

    
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
    local LLVM_VERSION=
    local LLVM_CHECKOUT_TAG=
    local LLVM_MINOR_VERSION=
    local PATCH_APPLY_LOCATIONS=()
    local PATCH_PATHS=()
    local PATCH_INFOS=()
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
            '--llvmVersion' )
                LLVM_VERSION=${2}
                shift 2
                ;;
            '--llvmCheckoutTag' )
                LLVM_CHECKOUT_TAG=${2}
                shift 2
                ;;
            '--llvmMinorVersion' )
                LLVM_MINOR_VERSION=${2}
                shift 2
                ;;
            '--patchApplyLocation' )
                PATCH_APPLY_LOCATIONS+=(${2})
                shift 2
                ;;
            '--patchPath' )
                PATCH_PATHS+=(${2})
                shift 2
                ;;
            '--patchInfo' )
                PATCH_INFOS+=(${2})
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


    # local readonly CHECKOUTED_DIR=`generateCheckoutRootDirectoryName ${LLVM_VERSION} ${LLVM_MINOR_VERSION}`
    local readonly CHECKOUTED_DIR="."


    if [ ${TASK_CHECKOUT} ]; then
       # executeCheckoutBySVN ${LLVM_VERSION} ${LLVM_MINOR_VERSION}
       executeCheckoutByGIT ${LLVM_CHECKOUT_TAG}

       if [ $? -ne 0 ]; then
           echo "abort executeCheckoutByGIT"
           exit 1
       fi
    fi
    
    if [ ${TASK_PATCH} ]; then
       if [ ${#PATCH_PATHS[@]} -eq ${#PATCH_APPLY_LOCATIONS[@]} ]; then
           local i
           for ((i = 0; i < ${#PATCH_PATHS[@]}; ++i)); do
               # executePatchBySVN ${CHECKOUTED_DIR} ${PATCH_APPLY_LOCATIONS[$i]} ${PATCH_PATHS[$i]}
               executePatchByGIT ${CHECKOUTED_DIR} ${PATCH_APPLY_LOCATIONS[$i]} ${PATCH_PATHS[$i]}

               if [ $? -ne 0 ]; then
                   echo "abort executePatchBySVN"
                   exit 1
               fi
           done
       fi

       local readonly EXTRACT_PATTERN='([^;]+);(.*)'
       local PATCH_INFO
       for PATCH_INFO in "${PATCH_INFOS[@]}"; do
           local PATCH_APPLY_LOCATION=$( echo "${PATCH_INFO}" | sed -r "s/${EXTRACT_PATTERN}/\1/" )
           local PATCH_PATH=$( echo "${PATCH_INFO}" | sed -r "s/${EXTRACT_PATTERN}/\2/" )

           if $( [ -n ${PATCH_APPLY_LOCATION} ] && [ -n ${PATCH_PATH} ] ); then
               executePatchBySVN ${CHECKOUTED_DIR} ${PATCH_APPLY_LOCATION} ${PATCH_PATH}

               if [ $? -ne 0 ]; then
                   echo "abort executePatchBySVN"
                   exit 1
               fi
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



