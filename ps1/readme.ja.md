<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#sec-1">1. 使用方法</a></li>
<li><a href="#sec-2">2. セルフビルドに必要なソフトウェア</a>
<ul>
<li><a href="#sec-2-1">2.1. Visual Studio 2013/2012/2010</a></li>
<li><a href="#sec-2-2">2.2. Subversion</a></li>
<li><a href="#sec-2-3">2.3. CMake</a></li>
<li><a href="#sec-2-4">2.4. Python 2.7.x</a></li>
<li><a href="#sec-2-5">2.5. GnuWin32</a></li>
</ul>
</li>
<li><a href="#sec-3">3. セルフビルド</a>
<ul>
<li><a href="#sec-3-1">3.1. パッチ</a></li>
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

## Visual Studio 2013/2012/2010<a id="sec-2-1" name="sec-2-1"></a>

どれでもOK  

## Subversion<a id="sec-2-2" name="sec-2-2"></a>

<http://tortoisesvn.net/>  

ソリューションビルド時にsvnコマンドラインが呼び出されるのでTortoiseSVNにパスが通っている必要がある。  
checkout/updateだけならCYGWINのsvnで可能だがお勧めしない。  
svnを呼び出してリビジョンナンバーなどを埋め込んだヘッダファイルを生成したりするが  
CYGWINのsvnだとパス解釈が正しく実行されない場合がありビルド時に該当ファイルがないといわれてしまうケースがある。  
なのでCYGWINのshellなどから実行しないほうがよい。  

## CMake<a id="sec-2-3" name="sec-2-3"></a>

<http://www.cmake.org/>  

Windows ZIPをダウンロードして何処かへ展開。  
Visual Studio ソリューション＆プロジェクトファイル生成と、カスタムビルドステップ時のスクリプト実行で使用される。  
sample.ps1でパスを設定する必要があります。  

## Python 2.7.x<a id="sec-2-4" name="sec-2-4"></a>

<http://www.python.org/>  
<http://www.python.org/download/>  

Python 2.7.x Windows X86-64 Installer を使用  
3.x 系は使用しない。  
cmake で LLVMのソリューションファイルを生成する際に必要。  
sample.ps1でパスを設定する必要があります。  

## GnuWin32<a id="sec-2-5" name="sec-2-5"></a>

<http://sourceforge.net/projects/getgnuwin32/>     

カスタムビルドステップで使用される。  
sample.ps1でパスを設定する必要があります。  

# セルフビルド<a id="sec-3" name="sec-3"></a>

Power Shell版を使用します。  

llvm-build-shellsでは以下を一括で行います。  
1.  LLVMチェックアウト
2.  パッチ適用(optional)
3.  cmakeによるLLVMソリューションファイル生成
4.  Visual Studio(MSBuild)によるビルド

ビルドするターゲットプラットフォーム(64/32)、コンフィグレーション(release/debug)の指定が可能です。  

## パッチ<a id="sec-3-1" name="sec-3-1"></a>

sample.ps1でパッチのパスを設定する必要があります。
