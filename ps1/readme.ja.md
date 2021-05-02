
# Table of Contents

1.  [使用方法](#org86be5a2)
2.  [セルフビルドに必要なソフトウェア](#org49c9536)
    1.  [Visual Studio 2019/2017](#org37e9efd)
    2.  [Git[必須]](#orgfba9a0f)
    3.  [CMake[必須]](#org765ad58)
    4.  [Python 3.6.x[必須]](#org1d8c1cc)
    5.  [Python 2.7.x[必須]](#orgf2799a0)
    6.  [MSYS2[推奨]](#org728a58a)
    7.  [GnuWin32[非推奨]](#org67656b5)
3.  [必要なソフトウェアのダウンロードサポート](#org2793be0)
    1.  [<del>MSYS2について</del> (現在非推奨)](#org86248d0)
4.  [セルフビルド](#org87c7e4d)
    1.  [パッチ](#org04fa8bb)



<a id="org86be5a2"></a>

# 使用方法

このシェルではWindowsのLLVMがビルド可能です。  
llvm-builder.ps1が本体です。  
sample.ps1が呼び出しサンプルです。  
patchパスなど必要に応じて編集してください。  
CYGWINやMSYSから実行すると実行時パス解釈がおかしくなるためWindowsのCMDかエクスプローラーから実行推奨。  


<a id="org49c9536"></a>

# セルフビルドに必要なソフトウェア

以下が必要になります。  


<a id="org37e9efd"></a>

## Visual Studio 2019/2017

どれでもOK  
LLVMは2015/2013/2012/2010のサポートを終了しました。  


<a id="orgfba9a0f"></a>

## Git[必須]

<https://git-scm.com/download/win>  

PortableGit を使用します  
sample.ps1でパスを設定する必要があります。  


<a id="org765ad58"></a>

## CMake[必須]

<http://www.cmake.org/>  

Windows ZIPをダウンロードして何処かへ展開。  
なるべく最新版を使用してください。  
Visual Studio ソリューション＆プロジェクトファイル生成と、カスタムビルドステップ時のスクリプト実行で使用される。  
sample.ps1でパスを設定する必要があります。  


<a id="org1d8c1cc"></a>

## Python 3.6.x[必須]

<http://repo.msys2.org/mingw/x86_64/>  
<http://repo.msys2.org/mingw/i686/>  

LLVM 12.0.X からは Python 3.6.x(msys2) 以上を使用します。  
2.x 系は使用しない。  
cmake で LLVM のソリューションファイルを生成する際に必要。  
sample.ps1でパスを設定する必要があります。  


<a id="orgf2799a0"></a>

## Python 2.7.x[必須]

<http://repo.msys2.org/mingw/x86_64/>  
<http://repo.msys2.org/mingw/i686/>  

LLVM 11.0.X までは Python 2.7.x(msys2) を使用します。  
3.x 系は使用しない。  
cmake で LLVM のソリューションファイルを生成する際に必要。  
sample.ps1でパスを設定する必要があります。  


<a id="org728a58a"></a>

## MSYS2[推奨]

<span class="underline">pacmanによるアップデートはmsys2の挙動が変わるので非推奨。</span>  

<https://repo.msys2.org/distrib/x86_64/>  
tools-installer.ps1 でダウンロードした各種パッケージ展開のためにmsys2-base-x86\_64を使用する  
Python2, Python3 もmsys2用が展開される  

tools-installer.ps1 で展開後に  
sample.ps1でパスを設定する必要があります。  


<a id="org67656b5"></a>

## GnuWin32[非推奨]

<http://sourceforge.net/projects/getgnuwin32/>     

カスタムビルドステップで使用される。  
sample.ps1でパスを設定する必要があります。  


<a id="org2793be0"></a>

# 必要なソフトウェアのダウンロードサポート

`./tools-latest-version/tools-installer.ps1`  
を使用すると、  
`./tools-latest-version/tools-installer.options` に記述されているソフトウェアが  
`./tools-latest-version/` にダウンロード＆展開されます。  

`sample.ps1` に記述するツールパスは `./tools-latest-version/` へ展開されたパスを使用する。  

デフォルトでは PortableGit, Cmake, Python2.7.x(msys2) がダウンロードされます。  


<a id="org86248d0"></a>

## <del>MSYS2について</del> (現在非推奨)

展開後に自動起動する MinGW64 シェルにおいて  

    $ cd /tmp
    $ ./setup-msys2.sh

を実行して、MSYS2を最新の状態に更新する。  
これを行わないとPython2.7.xやPerlがインストールされない。  

プロキシ経由している場合は `setup-msys2.sh` 実行前に  
`setup-msys2.options` を編集してhttp\_proxy 等の設定を行う必要がある。  


<a id="org87c7e4d"></a>

# セルフビルド

Power Shell版を使用します。  

llvm-build-shellsでは以下を一括で行います。  

-   LLVMレポジトリのクローンとチェックアウト
-   パッチ適用(optional)
-   cmakeによるLLVMソリューションファイル生成
-   Visual Studio(MSBuild)によるビルド

ビルドするターゲットプラットフォーム(64/32)、コンフィグレーション(release/debug)の指定が可能です。  


<a id="org04fa8bb"></a>

## パッチ

sample.ps1でパッチのパスを設定する必要があります。  

[Patch Details](../patch/details.md)  

