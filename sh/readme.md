<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#sec-1">1. 使用方法</a></li>
<li><a href="#sec-2">2. セルフビルドに必要なソフトウェア</a>
<ul>
<li><a href="#sec-2-1">2.1. Subversion</a></li>
<li><a href="#sec-2-2">2.2. cmake</a></li>
<li><a href="#sec-2-3">2.3. python 2.7.x</a></li>
</ul>
</li>
<li><a href="#sec-3">3. セルフビルド</a></li>
</ul>
</div>
</div>



# 使用方法<a id="sec-1" name="sec-1"></a>

このシェルではLinux or cygwinのLLVMがビルド可能です。  
llvm-builder.shが本体です。  
sample.shが呼び出しサンプルです。  

# セルフビルドに必要なソフトウェア<a id="sec-2" name="sec-2"></a>

以下が必要になります。  

## Subversion<a id="sec-2-1" name="sec-2-1"></a>

<http://tortoisesvn.net/>  

    $ sudo apt-get install subversion subversion-tools

## cmake<a id="sec-2-2" name="sec-2-2"></a>

    $ sudo apt-get install cmake

最新版の場合は↓からダウンロード  

<http://www.cmake.org/>  

cmake-3.1.0.tar.gzをダウンロードし解凍、ビルド、インストールを行う。  

    $ tar -xf cmake-3.1.0.tar.gz .
    $ cd cmake-3.1.0
    $ ./configure && make
    $ make install

## python 2.7.x<a id="sec-2-3" name="sec-2-3"></a>

入っているはず  

# セルフビルド<a id="sec-3" name="sec-3"></a>

自前でチェックアウトしてcmakeでLLVMソリューションファイルを生成するか、以下のshell scriptを使用してください。  
<https://github.com/yaruopooner/llvm-build-shells>  

Bash版を使用します。  

llvm-build-shellsでは以下を一括で行います。  
-   LLVMチェックアウト
-   パッチ適用(optional)
-   configureによるLLVM Makefile生成
-   ビルド
