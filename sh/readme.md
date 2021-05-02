
# Table of Contents

1.  [Usage](#org8b30d47)
2.  [Requirements](#org4368ed2)
    1.  [Git](#org0e3022f)
    2.  [CMake](#org8f470a2)
    3.  [Python 3.6.x](#org041c582)
    4.  [Python 2.7.x](#orgf6be4ce)
3.  [Self Build](#org73190a3)
    1.  [Patch](#org4e98871)



<a id="org8b30d47"></a>

# Usage

This script builds LLVM for Linux or Cygwin.  
llvm-builder.sh is the script itself.  
sample.sh is a call sample.  
Please edit it if necessary, for example the patch path.  


<a id="org4368ed2"></a>

# Requirements

The following is required.  


<a id="org0e3022f"></a>

## Git

    $ sudo apt-get install git


<a id="org8f470a2"></a>

## CMake

    $ sudo apt-get install cmake

If you want to use the latest version, please download from the following URL.  

<http://www.cmake.org/>  

download latest cmake, decompress, build and install.  

    $ wget --timestamping https://cmake.org/files/v3.6/cmake-3.6.2-win64-x64.zip
    $ tar -xvf cmake-3.6.2.tar.gz
    $ cd cmake-3.6.2
    $ ./configure && make
    $ make install


<a id="org041c582"></a>

## Python 3.6.x

Required from LLVM 12.0.X.  


<a id="orgf6be4ce"></a>

## Python 2.7.x

Required up to LLVM 11.0.X.  


<a id="org73190a3"></a>

# Self Build

Use Bash version.  

llvm-build-shells performs the following steps.  

-   LLVM repository clone and checkout
-   Apply patch(optional)
-   Makefile generation by cmake
-   Build


<a id="org4e98871"></a>

## Patch

You need to set the path of the patch in sample.sh.  

[Patch Details](../patch/details.md)  

