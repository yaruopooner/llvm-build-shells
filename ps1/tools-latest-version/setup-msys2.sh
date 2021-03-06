# -*- mode: shell-script ; coding: utf-8-unix -*-
#! /bin/sh


echo "---- ${0} : begin ----"


# environment detection 
if [ "${MSYSTEM}" = "MINGW64" ]; then
    readonly TARGET_PLATFORM=x86_64
elif [ "${MSYSTEM}" = "MINGW32" ]; then
    readonly TARGET_PLATFORM=i686
elif [ -z "${MSYSTEM}" ]; then
    echo "not detected MinGW."
    echo "please launch from MinGW64/32 shell."
    exit 1
fi
echo "detected MSYS : ${MSYSTEM}"



# preset vars
readonly BASE_PACKAGE_LIST=(
    svn
    git
    base-devel
    mingw-w64-${TARGET_PLATFORM}-toolchain
)

ADDITIONAL_PACKAGE_LIST=()


# overwrite vars load
if [ -e "./setup-msys2.options" ]; then
    . "./setup-msys2.options"
fi


readonly PACKAGE_LIST=( "${BASE_PACKAGE_LIST[@]}" "${ADDITIONAL_PACKAGE_LIST[@]}" )


echo "---- ${0} : requested package list ----"


printf "%s\n" "${PACKAGE_LIST[@]}"


echo "---- ${0} : refresh and upgrade ----"


# pacman <operation> [options] [targets]
# Operation
# -S --sync
# Options
# -y, --refresh        サーバーから最新のパッケージデータベースをダウンロード(-yy で最新の場合も強制的に更新を行う)
# -u, --sysupgrade     インストールしたパッケージのアップグレード (-uu でダウングレードを有効)
# --needed             最新のパッケージを再インストールさせない

pacman -Syuu --noconfirm


echo "---- ${0} : install package ----"


pacman -S --needed --noconfirm "${PACKAGE_LIST[@]}"


echo "---- ${0} : end ----"

