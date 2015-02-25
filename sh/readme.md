<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#sec-1">1. Usage</a></li>
<li><a href="#sec-2">2. Requirements</a>
<ul>
<li><a href="#sec-2-1">2.1. Subversion</a></li>
<li><a href="#sec-2-2">2.2. CMake</a></li>
<li><a href="#sec-2-3">2.3. Python 2.7.x</a></li>
</ul>
</li>
<li><a href="#sec-3">3. Self Build</a>
<ul>
<li><a href="#sec-3-1">3.1. Patch</a></li>
</ul>
</li>
</ul>
</div>
</div>



# Usage<a id="sec-1" name="sec-1"></a>

This shell can build LLVM of Linux or CYGWIN.  
llvm-builder.sh is body.  
sample.sh is call sample.  
Please edit if necessary, such as patch path.  

# Requirements<a id="sec-2" name="sec-2"></a>

The following is required.  

## Subversion<a id="sec-2-1" name="sec-2-1"></a>

<http://tortoisesvn.net/>  

    $ sudo apt-get install subversion subversion-tools

## CMake<a id="sec-2-2" name="sec-2-2"></a>

    $ sudo apt-get install cmake

Download from below URL in the case of the latest version.  

<http://www.cmake.org/>  

cmake-3.1.0.tar.gz download and decompress, do build and install.  

    $ tar -xf cmake-3.1.0.tar.gz .
    $ cd cmake-3.1.0
    $ ./configure && make
    $ make install

## Python 2.7.x<a id="sec-2-3" name="sec-2-3"></a>

It should have contain it if Linux.  

# Self Build<a id="sec-3" name="sec-3"></a>

Use Bash version.  

llvm-build-shells performs the following step at a time.  
1.  LLVM checkout
2.  Apply patch(optional)
3.  Makefile generation by configure
4.  Build

## Patch<a id="sec-3-1" name="sec-3-1"></a>

You need to set the PATH of patch in sample.sh.
