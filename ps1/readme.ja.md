<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#sec-1">1. 使用方法</a></li>
<li><a href="#sec-2">2. セルフビルドに必要なソフトウェア</a>
<ul>
<li><a href="#sec-2-1">2.1. Visual Studio 2019/2017/2015/2013/2012/2010</a></li>
<li><a href="#sec-2-2">2.2. Git[必須]</a></li>
<li><a href="#sec-2-3">2.3. CMake[必須]</a></li>
<li><a href="#sec-2-4">2.4. Python 2.7.x[推奨]</a></li>
<li><a href="#sec-2-5">2.5. MSYS2[非推奨]</a></li>
<li><a href="#sec-2-6">2.6. GnuWin32[非推奨]</a></li>
</ul>
</li>
<li><a href="#sec-3">3. 必要なソフトウェアのダウンロードサポート</a>
<ul>
<li><a href="#sec-3-1">3.1. <del>MSYS2について</del> (現在非推奨)</a></li>
</ul>
</li>
<li><a href="#sec-4">4. セルフビルド</a>
<ul>
<li><a href="#sec-4-1">4.1. パッチ</a></li>
</ul>
</li>
</ul>
</div>
</div>



# 使用方法<a id="sec-1" name="sec-1"></a>

このシェルではWindowsのLLVMがビルド可能です。  
llvm-builder.ps1が本体です。  
sample.ps1が呼び出しサンプルです。  
patchパスなど必要に応じて編集してください。  
CYGWINやMSYSから実行すると実行時パス解釈がおかしくなるためWindowsのCMDかエクスプローラーから実行推奨。  

# セルフビルドに必要なソフトウェア<a id="sec-2" name="sec-2"></a>

以下が必要になります。  

## Visual Studio 2019/2017/2015/2013/2012/2010<a id="sec-2-1" name="sec-2-1"></a>

どれでもOK  

## Git[必須]<a id="sec-2-2" name="sec-2-2"></a>

<https://git-scm.com/download/win>  

PortableGit を使用します  
sample.ps1でパスを設定する必要があります。  

## CMake[必須]<a id="sec-2-3" name="sec-2-3"></a>

<http://www.cmake.org/>  

Windows ZIPをダウンロードして何処かへ展開。  
Visual Studio ソリューション＆プロジェクトファイル生成と、カスタムビルドステップ時のスクリプト実行で使用される。  
sample.ps1でパスを設定する必要があります。  

## Python 2.7.x[推奨]<a id="sec-2-4" name="sec-2-4"></a>

<http://repo.msys2.org/mingw/x86_64/>  
<http://repo.msys2.org/mingw/i686/>  

Python 2.7.x(msys2) を使用します。  
3.x 系は使用しない。  
cmake で LLVM のソリューションファイルを生成する際に必要。  
sample.ps1でパスを設定する必要があります。  

## MSYS2[非推奨]<a id="sec-2-5" name="sec-2-5"></a>

<span class="underline">msys2のアップデートにより挙動が変わるので非推奨に変更。</span>  

<http://jaist.dl.sourceforge.net/project/msys2/Base/x86_64/>  

Python, Perl をサポート。  
PerlはWin32版ビルドでのみ必要。  
個別にPythonとPerlをインストールするより楽。  
ポータブル版を使用するので環境を汚さない。  
sample.ps1でパスを設定する必要があります。  

## GnuWin32[非推奨]<a id="sec-2-6" name="sec-2-6"></a>

<http://sourceforge.net/projects/getgnuwin32/>     

カスタムビルドステップで使用される。  
sample.ps1でパスを設定する必要があります。  

# 必要なソフトウェアのダウンロードサポート<a id="sec-3" name="sec-3"></a>

`./tools-latest-version/tools-installer.ps1`  
を使用すると、  
`./tools-latest-version/tools-installer.options` に記述されているソフトウェアが  
`./tools-latest-version/` にダウンロード＆展開されます。  

`sample.ps1` に記述するツールパスは `./tools-latest-version/` へ展開されたパスを使用する。  

デフォルトでは PortableGit, Cmake, Python2.7.x(msys2) がダウンロードされます。  

## <del>MSYS2について</del> (現在非推奨)<a id="sec-3-1" name="sec-3-1"></a>

展開後に自動起動する MinGW64 シェルにおいて  

    $ cd /tmp
    $ ./setup-msys2.sh

を実行して、MSYS2を最新の状態に更新する。  
これを行わないとPython2.7.xやPerlがインストールされない。  

プロキシ経由している場合は `setup-msys2.sh` 実行前に  
`setup-msys2.options` を編集してhttp\_proxy 等の設定を行う必要がある。  

# セルフビルド<a id="sec-4" name="sec-4"></a>

Power Shell版を使用します。  

llvm-build-shellsでは以下を一括で行います。  
-   LLVMレポジトリのクローンとチェックアウト
-   パッチ適用(optional)
-   cmakeによるLLVMソリューションファイル生成
-   Visual Studio(MSBuild)によるビルド

ビルドするターゲットプラットフォーム(64/32)、コンフィグレーション(release/debug)の指定が可能です。  

## パッチ<a id="sec-4-1" name="sec-4-1"></a>

sample.ps1でパッチのパスを設定する必要があります。  

[Patch Details](../patch/details.md)
