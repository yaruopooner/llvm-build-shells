<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#sec-1">1. Usage</a></li>
<li><a href="#sec-2">2. Requirements</a>
<ul>
<li><a href="#sec-2-1">2.1. Visual Studio 2019/2017</a></li>
<li><a href="#sec-2-2">2.2. Git[required]</a></li>
<li><a href="#sec-2-3">2.3. CMake[required]</a></li>
<li><a href="#sec-2-4">2.4. Python 2.7.x[recommend]</a></li>
<li><a href="#sec-2-5">2.5. MSYS2[unrecommend]</a></li>
<li><a href="#sec-2-6">2.6. GnuWin32[unrecommend]</a></li>
</ul>
</li>
<li><a href="#sec-3">3. Required software download support</a>
<ul>
<li><a href="#sec-3-1">3.1. <del>about MSYS2</del> (unrecommend)</a></li>
</ul>
</li>
<li><a href="#sec-4">4. Self Build</a>
<ul>
<li><a href="#sec-4-1">4.1. Patch</a></li>
</ul>
</li>
</ul>
</div>
</div>



# Usage<a id="sec-1" name="sec-1"></a>

This shell can build LLVM of Windows.  
llvm-builder.ps1 is body.  
sample.ps1 is call sample.  
Please edit if neccessary, such as patch path.  
Launch of this shell should not be done the CYGWIN and MSYS.  
because, shell is wrong the path interpretation.  
There is a need to launch from the Windows CMD or EXPLORER.  

# Requirements<a id="sec-2" name="sec-2"></a>

The following is required.  

## Visual Studio 2019/2017<a id="sec-2-1" name="sec-2-1"></a>

any ok.  
LLVM has ended support for the 2015/2013/2012/2010.  

## Git[required]<a id="sec-2-2" name="sec-2-2"></a>

<https://git-scm.com/download/win>  

Use the PortableGit.  
You need to set the PATH in sample.ps1.  

## CMake[required]<a id="sec-2-3" name="sec-2-3"></a>

<http://www.cmake.org/>  

You download The Windows ZIP and decompress to somewhere.  
Please use the latest version.  
CMake generate a Visual Studio solution and project file.  
And it is used in the execution on script of custom build step.  
You need to set the PATH in sample.ps1.  

## Python 2.7.x[recommend]<a id="sec-2-4" name="sec-2-4"></a>

<http://repo.msys2.org/mingw/x86_64/>  
<http://repo.msys2.org/mingw/i686/>  

Use Python 2.7.x (msys2).  
Should not use 3.x  
Required when CMake to generate the project files of LLVM.  
You need to set the PATH in sample.ps1.  

## MSYS2[unrecommend]<a id="sec-2-5" name="sec-2-5"></a>

<span class="underline">Behavior changed by updating msys2 and changed to deprecated.</span>  

<http://jaist.dl.sourceforge.net/project/msys2/Base/x86_64/>  

Python and Perl support.  
Perl is also required when Win32 build.  
Easier than individually install Python and Perl.  
Does not pollute the environment because it uses the portable version.  
You need to set the PATH in sample.ps1.  

## GnuWin32[unrecommend]<a id="sec-2-6" name="sec-2-6"></a>

<http://sourceforge.net/projects/getgnuwin32/>     

It is used in a custom build step.  
You need to set the PATH in sample.ps1.  

# Required software download support<a id="sec-3" name="sec-3"></a>

`./tools-latest-version/tools-installer.ps1`  
When you use this script,  
Described software in `./tools-latest-version/tools-installer.options` will be downloaded and archive-expand to `./tools-latest-version/`   

TOOL-PATH for described to a `sample.ps1` , use the `./tools-latest-version/` that has been archive-expand.  

By default, PortableGit and Cmake and Python 2.7.x (msys2) will be downloaded.  

## <del>about MSYS2</del> (unrecommend)<a id="sec-3-1" name="sec-3-1"></a>

MinGW64 shell is auto launch after archive-expand.  

    $ cd /tmp
    $ ./setup-msys2.sh

When you do this, MSYS2 update latest environment.  
If don't do this, Python2.7x and Perl not install.  

If you use proxy, before `setup-msys2.sh` execution  
it is necessary to set such http\_proxy by editing the `setup-msys2.options` .  

# Self Build<a id="sec-4" name="sec-4"></a>

Use Power Shell version.  

llvm-build-shells performs the following step at a time.  
-   LLVM repository clone and checkout
-   apply patch(optional)
-   project files generation by CMake
-   build by Visual Studio(MSBuild)

The following parameters designatable at llvm-build-shells.  
-   build target platform(64/32)
-   build configuration(release/debug)

## Patch<a id="sec-4-1" name="sec-4-1"></a>

You need to set the PATH of patch in sample.ps1.  

[Patch Details](../patch/details.md)
