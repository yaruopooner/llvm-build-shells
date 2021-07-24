
# Table of Contents

1.  [Usage](#org0e66c85)
2.  [Requirements](#orgd8bab76)
    1.  [Visual Studio 2019/2017](#org42f325c)
    2.  [Git[required]](#orgcd47d63)
    3.  [CMake[required]](#orgd7cb239)
    4.  [Python 3.6.x[required]](#orga62f16c)
    5.  [Python 2.7.x[required]](#orgbca5119)
    6.  [MSYS2[recommend]](#org01bb85d)
    7.  [GnuWin32[unrecommend]](#orgd3af86e)
3.  [Required software download support](#org6dba492)
    1.  [<del>about MSYS2</del> (unrecommend)](#org0d85b4f)
4.  [Self Build](#org8fb6acd)
    1.  [Patch](#orgc0109d1)



<a id="org0e66c85"></a>

# Usage

This shell can build LLVM of Windows.  
llvm-builder.ps1 is body.  
sample.ps1 is call sample.  
Please edit if neccessary, such as patch path.  
Launch of this shell should not be done the CYGWIN and MSYS.  
because, shell is wrong the path interpretation.  
There is a need to launch from the Windows CMD or EXPLORER.  


<a id="orgd8bab76"></a>

# Requirements

The following is required.  


<a id="org42f325c"></a>

## Visual Studio 2019/2017

any ok.  
LLVM has ended support for the 2015/2013/2012/2010.  


<a id="orgcd47d63"></a>

## Git[required]

<https://git-scm.com/download/win>  

Use the PortableGit.  
You need to set the PATH in sample.ps1.  


<a id="orgd7cb239"></a>

## CMake[required]

<http://www.cmake.org/>  

You download The Windows ZIP and decompress to somewhere.  
Please use the latest version.  
CMake generate a Visual Studio solution and project file.  
And it is used in the execution on script of custom build step.  
You need to set the PATH in sample.ps1.  


<a id="orga62f16c"></a>

## Python 3.6.x[required]

<http://repo.msys2.org/mingw/x86_64/>  
<http://repo.msys2.org/mingw/i686/>  

Starting with LLVM 12.0.X, use Python 3.6.x (msys2) or higher.  
Use Python 3.6.x (msys2).  
Should not use 2.x  
Required when CMake to generate the project files of LLVM.  
You need to set the PATH in sample.ps1.  


<a id="orgbca5119"></a>

## Python 2.7.x[required]

<http://repo.msys2.org/mingw/x86_64/>  
<http://repo.msys2.org/mingw/i686/>  

Up to LLVM 11.0.X uses Python 2.7.x (msys2).  
Use Python 2.7.x (msys2).  
Should not use 3.x  
Required when CMake to generate the project files of LLVM.  
You need to set the PATH in sample.ps1.  


<a id="org01bb85d"></a>

## MSYS2[recommend]

<span class="underline">Updating with pacman is not recommended as it changes the behavior of msys2.</span>  

<https://repo.msys2.org/distrib/x86_64/>  
Use msys2-base-x86\_64 to decompress various packages downloaded with tools-installer.ps1 .  
Python2 and Python3 are also decompress for msys2.  

You need to set the path in sample.ps1 after extracting with tools-installer.ps1.  


<a id="orgd3af86e"></a>

## GnuWin32[unrecommend]

<http://sourceforge.net/projects/getgnuwin32/>     

It is used in a custom build step.  
You need to set the PATH in sample.ps1.  


<a id="org6dba492"></a>

# Required software download support

`./tools-latest-version/tools-installer.ps1`  
When you use this script,  
Described software in `./tools-latest-version/tools-installer.options` will be downloaded and archive-expand to `./tools-latest-version/`   

TOOL-PATH for described to a `sample.ps1` , use the `./tools-latest-version/` that has been archive-expand.  

By default, PortableGit and Cmake and Python 2.7.x (msys2) will be downloaded.  


<a id="org0d85b4f"></a>

## <del>about MSYS2</del> (unrecommend)

MinGW64 shell is auto launch after archive-expand.  

    $ cd /tmp
    $ ./setup-msys2.sh

When you do this, MSYS2 update latest environment.  
If don't do this, Python2.7x and Perl not install.  

If you use proxy, before `setup-msys2.sh` execution  
it is necessary to set such http\_proxy by editing the `setup-msys2.options` .  


<a id="org8fb6acd"></a>

# Self Build

Use Power Shell version.  

llvm-build-shells performs the following step at a time.  

-   LLVM repository clone and checkout
-   apply patch(optional)
-   project files generation by CMake
-   build by Visual Studio(MSBuild)

The following parameters designatable at llvm-build-shells.  

-   build target platform(64/32)
-   build configuration(release/debug)


<a id="orgc0109d1"></a>

## Patch

You need to set the PATH of patch in sample.ps1.  

[Patch Details](../patch/details.md)  

