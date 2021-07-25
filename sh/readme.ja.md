
# Table of Contents

1.  [使用方法](#org561207b)
2.  [セルフビルドに必要なソフトウェア](#org1cb250c)
    1.  [Git](#org56b9e26)
    2.  [CMake](#orgc47509d)
    3.  [Ninja](#orgd276e28)
    4.  [Python 3.6.x](#org6b6e0de)
    5.  [Python 2.7.x](#orgcad9c5c)
3.  [セルフビルド](#org2ad2c74)
    1.  [パッチ](#org119bae5)



<a id="org561207b"></a>

# 使用方法

このシェルではLinux or CYGWINのLLVMがビルド可能です。  
llvm-builder.shが本体です。  
sample.shが呼び出しサンプルです。  
patchパスなど必要に応じて編集してください。  


<a id="org1cb250c"></a>

# セルフビルドに必要なソフトウェア

以下が必要になります。  


<a id="org56b9e26"></a>

## Git

    $ sudo apt-get install git


<a id="orgc47509d"></a>

## CMake

    $ sudo apt-get install cmake

最新版の場合は↓からダウンロード  

<http://www.cmake.org/>  

最新版をダウンロードし解凍、ビルド、インストールを行う。  

    $ wget --timestamping https://cmake.org/files/v3.6/cmake-3.6.2-win64-x64.zip
    $ tar -xvf cmake-3.6.2.tar.gz
    $ cd cmake-3.6.2
    $ ./configure && make
    $ make install


<a id="orgd276e28"></a>

## Ninja

    $ sudo apt-get install ninja-build


<a id="org6b6e0de"></a>

## Python 3.6.x

LLVM 12.0.X から必要。  


<a id="orgcad9c5c"></a>

## Python 2.7.x

LLVM 11.0.X までは必要。  


<a id="org2ad2c74"></a>

# セルフビルド

Bash版を使用します。  

llvm-build-shellsでは以下を一括で行います。  

-   LLVMレポジトリのクローンとチェックアウト
-   パッチ適用(optional)
-   cmakeによるLLVM ビルドファイル生成(makefile or build.ninja)
-   ビルド


<a id="org119bae5"></a>

## パッチ

sample.shでパッチのパスを設定する必要があります。  

[Patch Details](../patch/details.md)  

