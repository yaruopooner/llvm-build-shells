
# Table of Contents

1.  [Usage](#org47522eb)
2.  [Requirements](#orgc7773eb)
    1.  [Git](#org14dd8dd)
    2.  [CMake](#org2335b1b)
    3.  [Ninja](#org6abf5e5)
    4.  [Python 3.6.x](#orgec536be)
    5.  [Python 2.7.x](#org74dec8d)
3.  [Self Build](#org4668263)
    1.  [Patch](#org27d1a51)



<a id="org47522eb"></a>

# Usage

This script builds LLVM for Linux or Cygwin.  
llvm-builder.sh is the script itself.  
sample.sh is a call sample.  
Please edit it if necessary, for example the patch path.  


<a id="orgc7773eb"></a>

# Requirements

The following is required.  


<a id="org14dd8dd"></a>

## Git

    $ sudo apt-get install git


<a id="org2335b1b"></a>

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


<a id="org6abf5e5"></a>

## Ninja

    $ sudo apt-get install ninja-build


<a id="orgec536be"></a>

## Python 3.6.x

Required from LLVM 12.0.X.  


<a id="org74dec8d"></a>

## Python 2.7.x

Required up to LLVM 11.0.X.  


<a id="org4668263"></a>

# Self Build

Use Bash version.  

llvm-build-shells performs the following steps.  

-   LLVM repository clone and checkout
-   Apply patch(optional)
-   Build files generation by cmake(makefile or build.ninja)
-   Build


<a id="org27d1a51"></a>

## Patch

You need to set the path of the patch in sample.sh.  

[Patch Details](../patch/details.md)  

