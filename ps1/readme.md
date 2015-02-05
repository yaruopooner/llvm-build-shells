<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#sec-1">1. 使用方法</a></li>
<li><a href="#sec-2">2. セルフビルドに必要なソフトウェア</a>
<ul>
<li><a href="#sec-2-1">2.1. Visual Studio 2013/2012/2010</a></li>
<li><a href="#sec-2-2">2.2. Subversion</a></li>
<li><a href="#sec-2-3">2.3. cmake</a></li>
<li><a href="#sec-2-4">2.4. python 2.7.x</a></li>
<li><a href="#sec-2-5">2.5. GnuWin32</a></li>
</ul>
</li>
<li><a href="#sec-3">3. セルフビルド</a></li>
</ul>
</div>
</div>



# 使用方法<a id="sec-1" name="sec-1"></a>

このシェルではWindowsのLLVMがビルド可能です。  
llvm-builder.ps1が本体です。  
sample.ps1が呼び出しサンプルです。  
cygwinやmsysから実行すると実行時パス解釈がおかしくなるためWindowsのcmdから実行推奨。  

# セルフビルドに必要なソフトウェア<a id="sec-2" name="sec-2"></a>

以下が必要になります。  

## Visual Studio 2013/2012/2010<a id="sec-2-1" name="sec-2-1"></a>

どれでもOK  

## Subversion<a id="sec-2-2" name="sec-2-2"></a>

<http://tortoisesvn.net/>  

ソリューションビルド時にsvnコマンドラインが呼び出されるのでTortoiseSVNにパスが通っている必要がある。  
checkout/updateだけならcygwinのsvnで可能だがお勧めしない。  
svnを呼び出してリビジョンナンバーなどを埋め込んだヘッダファイルを生成したりするが  
cygwinのsvnだとパス解釈が正しく実行されない場合がありビルド時に該当ファイルがないといわれてしまうケースがある。  
なのでcygwinのshellなどから実行しないほうがよい。  

## cmake<a id="sec-2-3" name="sec-2-3"></a>

<http://www.cmake.org/>  

Windows ZIPをダウンロードして何処かへ展開。  
Visual Studio ソリューション＆プロジェクトファイル生成と、カスタムビルドステップ時のスクリプト実行で使用される。  
Windows Sourceのほうはおすすめしない。  
自前ビルドしたところ、なぜかジェネレーターにVisual Studio系がなかった。なぜ？  

## python 2.7.x<a id="sec-2-4" name="sec-2-4"></a>

<http://www.python.org/>  
<http://www.python.org/download/>  

Python 2.7.x Windows X86-64 Installer を使用  
3.x 系は使用しない。  
cmake で LLVMのソリューションファイルを生成する際に必要。  

## GnuWin32<a id="sec-2-5" name="sec-2-5"></a>

<http://gnuwin32.sourceforge.net/>  
<http://sourceforge.net/projects/getgnuwin32/files/>  

カスタムビルドステップで使用される。  
grepなどを使用している模様。  

PATHに GnuWin32/bin を設定する場合は最後尾にしてパス検索順の最後にする。  
Visual Studio IDE上からビルドする場合はシステム環境変数のPATHへ追加しておく必要がある。  
環境変数を汚したくない場合はMSBuildでビルドするのがよい。  
MSBuildの場合は、ビルド実行直前に GnuWin32/bin にパスを通せばよいので、  
呼び出しbat内でset PATH=c:\GnuWin32\bin;%PATH%としておけばよい。  

# セルフビルド<a id="sec-3" name="sec-3"></a>

Power Shell版を使用します。  

llvm-build-shellsでは以下を一括で行います。  
-   LLVMチェックアウト
-   パッチ適用(optional)
-   cmakeによるLLVMソリューションファイル生成
-   Visual Studio(MSBuild)によるビルド

ビルドするターゲットプラットフォーム(64/32)、コンフィグレーション(release/debug)の指定が可能です。
