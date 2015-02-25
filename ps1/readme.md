<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#sec-1">1. Usage</a></li>
<li><a href="#sec-2">2. Requirements</a>
<ul>
<li><a href="#sec-2-1">2.1. Visual Studio 2013/2012/2010</a></li>
<li><a href="#sec-2-2">2.2. Subversion</a></li>
<li><a href="#sec-2-3">2.3. CMake</a></li>
<li><a href="#sec-2-4">2.4. Python 2.7.x</a></li>
<li><a href="#sec-2-5">2.5. GnuWin32</a></li>
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

This shell can build LLVM of Windows.  
llvm-builder.ps1 is body.  
sample.ps1 is call sample.  
Please edit if neccessary, such as patch path.  
Launch of this shell should not be done the CYGWIN and MSYS.  
because, shell is wrong the path interpretation.  
There is a need to launch from the Windows CMD or EXPLORER.  

# Requirements<a id="sec-2" name="sec-2"></a>

The following is required.  

## Visual Studio 2013/2012/2010<a id="sec-2-1" name="sec-2-1"></a>

any ok.  

## Subversion<a id="sec-2-2" name="sec-2-2"></a>

<http://tortoisesvn.net/>  

svn Should not use from CYGWIN or MSYS.  

## CMake<a id="sec-2-3" name="sec-2-3"></a>

<http://www.cmake.org/>  

You download The Windows ZIP and decompress to somewhere.  
CMake generate a Visual Studio solution and project file.  
And it is used in the execution on script of custom build step.  
You need to set the PATH in sample.ps1.  

## Python 2.7.x<a id="sec-2-4" name="sec-2-4"></a>

<http://www.python.org/>  
<http://www.python.org/download/>  

Use Python 2.7.x Windows X86-64 Installer.  
Should not use 3.x.  
Required when CMake to generate the project files of LLVM.  
You need to set the PATH in sample.ps1.  

## GnuWin32<a id="sec-2-5" name="sec-2-5"></a>

<http://sourceforge.net/projects/getgnuwin32/>     

It is used in a custom build step.  
You need to set the PATH in sample.ps1.  

# Self Build<a id="sec-3" name="sec-3"></a>

Use Power Shell version.  

llvm-build-shells performs the following step at a time.  
-   LLVM checkout
-   apply patch(optional)
-   project files generation by CMake
-   build by Visual Studio(MSBuild)

The following parameters designatable at llvm-build-shells.  
-   build target platform(64/32)
-   build configuration(release/debug)

## Patch<a id="sec-3-1" name="sec-3-1"></a>

You need to set the PATH of patch in sample.ps1.
