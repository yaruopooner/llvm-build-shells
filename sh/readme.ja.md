<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#sec-1">1. 使用方法</a></li>
<li><a href="#sec-2">2. セルフビルドに必要なソフトウェア</a>
<ul>
<li><a href="#sec-2-1">2.1. Subversion</a></li>
<li><a href="#sec-2-2">2.2. CMake</a></li>
<li><a href="#sec-2-3">2.3. Python 2.7.x</a></li>
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

このシェルではLinux or CYGWINのLLVMがビルド可能です。  
llvm-builder.shが本体です。  
sample.shが呼び出しサンプルです。  
patchパスなど必要に応じて編集してください。  

# セルフビルドに必要なソフトウェア<a id="sec-2" name="sec-2"></a>

以下が必要になります。  

## Subversion<a id="sec-2-1" name="sec-2-1"></a>

<http://tortoisesvn.net/>  

    $ sudo apt-get install subversion subversion-tools

## CMake<a id="sec-2-2" name="sec-2-2"></a>

    $ sudo apt-get install cmake

最新版の場合は↓からダウンロード  

<http://www.cmake.org/>  

cmake-3.1.0.tar.gzをダウンロードし解凍、ビルド、インストールを行う。  

    $ tar -xf cmake-3.1.0.tar.gz .
    $ cd cmake-3.1.0
    $ ./configure && make
    $ make install

## Python 2.7.x<a id="sec-2-3" name="sec-2-3"></a>

入っているはず  

# セルフビルド<a id="sec-3" name="sec-3"></a>

Bash版を使用します。  

llvm-build-shellsでは以下を一括で行います。  
1.  LLVMチェックアウト
2.  パッチ適用(optional)
3.  configureによるLLVM Makefile生成
4.  ビルド

## パッチ<a id="sec-3-1" name="sec-3-1"></a>

sample.shでパッチのパスを設定する必要があります。
