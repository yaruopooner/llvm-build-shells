$launchPath = Split-Path $myInvocation.MyCommand.path -Parent
$builderShell = Join-Path $launchPath 'llvm-builder.ps1'

$git = Join-Path $launchPath "tools-latest-version/PortableGit-2.23.0-x86_64/mingw64/bin"
$cmake = Join-Path $launchPath "tools-latest-version/cmake-3.19.5-win64-x64/bin"
$python = Join-Path $launchPath "tools-latest-version/msys64/mingw64/bin"
# $msys2 = Join-Path $launchPath "tools-latest-version/msys64/usr/bin"
# $msys2 = ( Join-Path $launchPath "tools-latest-version/msys64/mingw64/bin;" ) + ( Join-Path $launchPath "tools-latest-version/msys64/usr/bin" )
# $gnu32 = "c:/cygwin-x86_64/tmp/llvm-build-shells/ps1/tools-latest-version/GnuWin32/bin"


. $builderShell

$llvmCheckoutTag = "llvmorg-12.0.0"
$msvcProductName = 2019
# $msvcProductName = 2017


# LLVM ALL Build (full task)
executeBuilder -tasks @("CHECKOUT", "PATCH", "PROJECT", "BUILD") -llvmCheckoutTag $llvmCheckoutTag -msvcProductName $msvcProductName -platform 64 -configuration "Release" -gitPath $git -cmakePath $cmake -pythonPath $python


# LLVM Parts Build (full task)
# $target = "Clang libraries\libclang;Clang executables\clang-format"
# $target = "Clang libraries\libclang;Clang executables\clang-format;Clang executables\clang-include-fixer;Clang executables\clang-rename;Clang executables\clang-tidy"
# executeBuilder -tasks @("CHECKOUT", "PATCH", "PROJECT", "BUILD") -llvmCheckoutTag $llvmCheckoutTag -msvcProductName $msvcProductName -platform 64 -configuration "Release" -gitPath $git -cmakePath $cmake -pythonPath $python -target $target


# LLVM Parts Build (parts task)
# $target = "Clang libraries\libclang;Clang executables\clang-format"
# executeBuilder -tasks @("CHECKOUT", "PATCH") -llvmCheckoutTag $llvmCheckoutTag -gitPath $git
# executeBuilder -tasks @("PROJECT", "BUILD") -llvmCheckoutTag $llvmCheckoutTag -msvcProductName $msvcProductName -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -target $target
# executeBuilder -tasks @("PROJECT", "BUILD") -llvmCheckoutTag $llvmCheckoutTag -msvcProductName $msvcProductName -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python
# executeBuilder -tasks @("PROJECT", "GENERATE_BUILD_BAT") -llvmCheckoutTag $llvmCheckoutTag -msvcProductName $msvcProductName -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python
# executeBuilder -tasks @("BUILD") -llvmCheckoutTag $llvmCheckoutTag -msvcProductName $msvcProductName -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python
# executeBuilder -tasks @("PROJECT", "BUILD") -llvmCheckoutTag $llvmCheckoutTag -msvcProductName $msvcProductName -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python
# executeBuilder -tasks @("GENERATE_BUILD_BAT") -llvmCheckoutTag $llvmCheckoutTag -msvcProductName $msvcProductName -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python


# LLVM Parts Build (single task)
# $target = "Clang libraries\libclang;Clang executables\clang-format"
# executeBuilder -tasks @("CHECKOUT", "PATCH") -llvmCheckoutTag $llvmCheckoutTag -gitPath $git
# executeBuilder -tasks @("CHECKOUT") -llvmCheckoutTag $llvmCheckoutTag -gitPath $git
# executeBuilder -tasks @("PATCH") -llvmCheckoutTag $llvmCheckoutTag -gitPath $git
# executeBuilder -tasks @("CHECKOUT", "PATCH") -llvmCheckoutTag $llvmCheckoutTag -gitPath $git
# executeBuilder -tasks @("PROJECT") -llvmCheckoutTag $llvmCheckoutTag -msvcProductName $msvcProductName -platform 64 -cmakePath $cmake -pythonPath $python
# executeBuilder -tasks @("PROJECT") -llvmCheckoutTag $llvmCheckoutTag -msvcProductName $msvcProductName -platform 32 -cmakePath $cmake -pythonPath $python
# executeBuilder -tasks @("BUILD") -llvmCheckoutTag $llvmCheckoutTag -msvcProductName $msvcProductName -platform 64 -configuration "Release" -target $target
# executeBuilder -tasks @("BUILD") -llvmCheckoutTag $llvmCheckoutTag -msvcProductName $msvcProductName -platform 32 -configuration "Release" -target $target


# Test
# executeBuilder -tasks @("TEST") -llvmCheckoutTag $llvmCheckoutTag -msvcProductName $msvcProductName -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python
# executeBuilder -tasks @("TEST") -llvmCheckoutTag $llvmCheckoutTag -msvcProductName $msvcProductName -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python
# executeBuilder -tasks @("PROJECT") -llvmCheckoutTag $llvmCheckoutTag -msvcProductName $msvcProductName -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python
# executeBuilder -tasks @("PROJECT") -llvmCheckoutTag $llvmCheckoutTag -msvcProductName $msvcProductName -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python



[Console]::ReadKey()
