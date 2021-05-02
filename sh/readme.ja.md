
# Table of Contents

1.  [使用方法](#org46a39ed)
2.  [セルフビルドに必要なソフトウェア](#org623912c)
    1.  [Git](#org31c5949)
    2.  [CMake](#org0ce101a)
    3.  [Python 3.6.x](#orgbc641b6)
    4.  [Python 2.7.x](#org631bb26)
3.  [セルフビルド](#org04a3e55)
    1.  [パッチ](#org198d65f)



<a id="org46a39ed"></a>

# 使用方法

このシェルではLinux or CYGWINのLLVMがビルド可能です。  
llvm-builder.shが本体です。  
sample.shが呼び出しサンプルです。  
patchパスなど必要に応じて編集してください。  


<a id="org623912c"></a>

# セルフビルドに必要なソフトウェア

以下が必要になります。  


<a id="org31c5949"></a>

## Git

    $ sudo apt-get install git


<a id="org0ce101a"></a>

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


<a id="orgbc641b6"></a>

## Python 3.6.x

LLVM 12.0.X から必要。  


<a id="org631bb26"></a>

## Python 2.7.x

LLVM 11.0.X までは必要。  


<a id="org04a3e55"></a>

# セルフビルド

Bash版を使用します。  

llvm-build-shellsでは以下を一括で行います。  

-   LLVMレポジトリのクローンとチェックアウト
-   パッチ適用(optional)
-   cmakeによるLLVM Makefile生成
-   ビルド


<a id="org198d65f"></a>

## パッチ

sample.shでパッチのパスを設定する必要があります。  

[Patch Details](../patch/details.md)  

