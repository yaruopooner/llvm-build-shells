# -*- mode: shell-script ; coding: utf-8-unix -*-
#! /bin/sh

# build passed : 1.7.34(0.282/5/3) 2014-12-17 13:43 x86_64 Cygwin

function usage()
{
    echo 'Usage: executeBuilder [OPTIONS]'
    echo
    echo 'Options:'
    echo ' --checkout'
    echo '     checkout LLVM by git'
    echo '     checkout tag is referenced from "llvm.git.options"'
    echo '     or'
    echo '     Specify option > --llvmCheckoutTag'
    echo ' --patch'
    echo '     apply patch by git'
    echo '     The patch file path is referenced from "llvm.git.options"'
    echo ' --configure'
    echo '     generate makefile by cmake'
    echo '     The additional option is referenced from "llvm.cmake.options"'
    echo ' --build'
    echo '     execute make'
    echo ' --llvmCheckoutTag "CHECKOUT_TAG_NAME"'
    echo '     The tag name to checkout from the LLVM repository'
    echo '     default is leatest version tag'
    echo ' --buildType "[Release|Debug]"'
    echo '     default is Release'
    echo ' --projectBuilder "[make|cmake]"'
    echo '     Specify generator to use for project builder'
    echo '     default is cmake'
    echo ' --help'
    echo '     This message'
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
declare -r LLVM_CMAKE_INFOS_FILE="llvm-cmake.options"
declare -r LLVM_CMAKE_INFOS_SRC_FILE="${LLVM_CMAKE_INFOS_FILE}.sample"

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

function loadGITCheckoutInfos()
{
    loadVariablesOnOptionFile "${LLVM_GIT_INFOS_FILE}" "${LLVM_GIT_INFOS_SRC_FILE}"
}

function loadCMakeInfos()
{
    loadVariablesOnOptionFile "${LLVM_CMAKE_INFOS_FILE}" "${LLVM_CMAKE_INFOS_SRC_FILE}"
}



function executeCheckoutByGIT()
{
    echo "----------git checkout phase----------"

    local -r REPOSITORY_NAME="${GitCheckoutInfos[RepositoryName]}"
    local -r REPOSITORY_URL="${GitCheckoutInfos[RepositoryURL]}"
    local -r FETCH="${GitCheckoutInfos[Fetch]}"
    local -r CHECKOUT_TAG=${1}
    local -rn ADDITIONAL_OPTIONS="${GitCheckoutInfos[AdditionalOptions]}"


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
    echo "repository directory : ${REPOSITORY_DIR}"
    echo "patch path           : ${PATCH_PATH}"
    echo "command              : git ${CMD_ARGS[@]}"
    pwd

    if [ ! -d ${REPOSITORY_DIR} ]; then
        echo "not found repository directory"
        return 1
    fi

    pushd ${REPOSITORY_DIR}

    git reset --hard

    git ${CMD_ARGS[@]}

    popd

    return 0
}


function executeConfigureByCMake()
{
    echo "----------configure by cmake phase----------"
    local -r REPOSITORY_NAME="${GitCheckoutInfos[RepositoryName]}"
    local -r CHECKOUT_TAG=${1}
    local -r BUILD_TYPE=${2}
    local -rn ADDITIONAL_OPTIONS="${CMakeInfos[AdditionalOptions]}"
    local -r BUILD_DIR="build"
    local -r BUILD_VERSION="${CHECKOUT_TAG}"
    local -r REQUIRE_VERSION="3.4.3"
    
    if ! is_valid_version "cmake" "${REQUIRE_VERSION}"; then
        echo "cmake not enough version"
        echo "current cmake version "$( get_command_version "cmake" )
        echo "require version ${REQUIRE_VERSION} or higher version"
        return 1
    fi

    echo "checkout repository directory : ${REPOSITORY_NAME}"
    echo "build type                    : ${BUILD_TYPE}"

    if [ ! -d ${REPOSITORY_NAME} ]; then
        echo "not found repository directory"
        return 2
    fi

    pushd .
    # build directory
    if [ ! -d ${BUILD_DIR} ]; then
        mkdir ${BUILD_DIR}
    fi
    cd ${BUILD_DIR}

    # build version directory
    if [ ! -d ${BUILD_VERSION} ]; then
        mkdir ${BUILD_VERSION}
    fi
    cd ${BUILD_VERSION}

    # build type directory
    if [ -d ${BUILD_TYPE} ]; then
        rm -rf ${BUILD_TYPE}
    fi
    mkdir ${BUILD_TYPE}
    cd ${BUILD_TYPE}

    local -r CMD_ARGS=("../../../${REPOSITORY_NAME}/llvm" "-DCMAKE_BUILD_TYPE=${BUILD_TYPE}" "${ADDITIONAL_OPTIONS[@]}")

    # echo "cmd_args:${CMD_ARGS[@]}"
    cmake ${CMD_ARGS[@]}

    popd

    return 0
}


function executeBuild()
{
    echo "----------build phase----------"

    local -r REPOSITORY_NAME="${GitCheckoutInfos[RepositoryName]}"
    local -r CHECKOUT_TAG=${1}
    local -r BUILD_TYPE=${2}
    local -r BUILD_DIR="build"
    local -r BUILD_VERSION="${CHECKOUT_TAG}"

    pushd .
    cd ${BUILD_DIR}
    cd ${BUILD_VERSION}
    cd ${BUILD_TYPE}

    make -j4

    popd

    return 0
}


function executeBuildByCMake()
{
    echo "----------build by cmake phase----------"

    local -r REPOSITORY_NAME="${GitCheckoutInfos[RepositoryName]}"
    local -r CHECKOUT_TAG=${1}
    local -r BUILD_TYPE=${2}
    local -r BUILD_DIR="build"
    local -r BUILD_VERSION="${CHECKOUT_TAG}"

    pushd .
    cd ${BUILD_DIR}
    cd ${BUILD_VERSION}
    cd ${BUILD_TYPE}

    cmake --build .

    popd

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


    loadGITCheckoutInfos
    loadCMakeInfos

    if [ ! ${LLVM_CHECKOUT_TAG} ]; then
        local -r DEFAULT_CHECKOUT_TAG="${GitCheckoutInfos[DefaultCheckoutTag]}"

        LLVM_CHECKOUT_TAG=${DEFAULT_CHECKOUT_TAG}
    fi

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
        executeConfigureByCMake ${LLVM_CHECKOUT_TAG} ${BUILD_TYPE}

        if [ $? -ne 0 ]; then
            echo "abort executeConfigureByCMake"
            exit 1
        fi
    fi

    if [ ${TASK_BUILD} ]; then
        case ${PROJECT_BUILDER} in
            'make' )
                executeBuild ${LLVM_CHECKOUT_TAG} ${BUILD_TYPE}

                if [ $? -ne 0 ]; then
                    echo "abort executeBuild"
                    exit 1
                fi
                ;;
            'cmake' )
                executeBuildByCMake ${LLVM_CHECKOUT_TAG} ${BUILD_TYPE}

                if [ $? -ne 0 ]; then
                    echo "abort executeBuildByCMake"
                    exit 1
                fi
                ;;
        esac
    fi
}



