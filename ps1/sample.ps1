$launchPath = Split-Path $myInvocation.MyCommand.path -Parent
$builderShell = Join-Path $launchPath 'llvm-builder.ps1'

$cmake = Join-Path $launchPath "tools-latest-version/cmake-3.14.1-win64-x64/bin"
$python = Join-Path $launchPath "tools-latest-version/mingw64/bin;"
# $msys2 = Join-Path $launchPath "tools-latest-version/msys64/usr/bin"
# $msys2 = ( Join-Path $launchPath "tools-latest-version/msys64/mingw64/bin;" ) + ( Join-Path $launchPath "tools-latest-version/msys64/usr/bin" )
# $gnu32 = "c:/cygwin-x86_64/tmp/llvm-build-shells/ps1/tools-latest-version/GnuWin32/bin"

# please refer document. : ../patch/details.org
$patchInfos = @( 
    @{ # llvm bug : fixed out of range access at container.
        applyLocation = "llvm/tools/clang/";
        absolutePath = ( Resolve-Path ( Join-Path $launchPath "../patch/bugfix000.patch" ) );
    }
    # ,@{ # llvm 4.00 under ? msvc ? : build error fixed patch for msvc2017(update0) & llvm 4.00 only, this problem fixed at llvm greater than 4.00.
    #     applyLocation = "llvm/";
    #     absolutePath = ( Resolve-Path ( Join-Path $launchPath "../patch/msvc2017-build-error-fixed.patch" ) );
    # }
    # ,@{ # This patch is for ac-clang of emacs package.
    #     applyLocation = "llvm/";
    #     absolutePath = ( Resolve-Path ( Join-Path $launchPath "../patch/invalidate-mmap.patch" ) );
    #     # absolutePath = "c:/cygwin-x86_64/home/yaruopooner/.emacs.d/.emacs25/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch";
    # }
)

. $builderShell

$llvmVersion = 800
# $llvmVersion = 700
$msvcProductName = 2019
# $msvcProductName = 2017


# LLVM ALL Build (full task)
executeBuilder -tasks @("CHECKOUT", "PATCH", "PROJECT", "BUILD") -llvmVersion $llvmVersion -msvcProductName $msvcProductName -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -patchInfos $patchInfos


# LLVM Parts Build (full task)
# $target = "Clang libraries\libclang;Clang executables\clang-format"
# $target = "Clang libraries\libclang;Clang executables\clang-format;Clang executables\clang-include-fixer;Clang executables\clang-rename;Clang executables\clang-tidy"
# executeBuilder -tasks @("CHECKOUT", "PATCH", "PROJECT", "BUILD") -llvmVersion $llvmVersion -msvcProductName $msvcProductName -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -patchInfos $patchInfos -target $target


# LLVM Parts Build (parts task)
# $target = "Clang libraries\libclang;Clang executables\clang-format"
# executeBuilder -tasks @("CHECKOUT", "PATCH") -llvmVersion $llvmVersion -patchInfos $patchInfos
# executeBuilder -tasks @("PROJECT", "BUILD") -llvmVersion $llvmVersion -msvcProductName $msvcProductName -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -target $target
# executeBuilder -tasks @("PROJECT", "BUILD") -llvmVersion $llvmVersion -msvcProductName $msvcProductName -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python
# executeBuilder -tasks @("PROJECT", "BUILD") -llvmVersion $llvmVersion -msvcProductName $msvcProductName -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python


# LLVM Parts Build (single task)
# $target = "Clang libraries\libclang;Clang executables\clang-format"
# executeBuilder -tasks @("CHECKOUT") -llvmVersion $llvmVersion
# executeBuilder -tasks @("PATCH") -llvmVersion $llvmVersion -patchInfos $patchInfos
# executeBuilder -tasks @("PROJECT") -llvmVersion $llvmVersion -msvcProductName $msvcProductName -platform 64 -cmakePath $cmake -pythonPath $python
# executeBuilder -tasks @("PROJECT") -llvmVersion $llvmVersion -msvcProductName $msvcProductName -platform 32 -cmakePath $cmake -pythonPath $python
# executeBuilder -tasks @("BUILD") -llvmVersion $llvmVersion -msvcProductName $msvcProductName -platform 64 -configuration "Release" -target $target
# executeBuilder -tasks @("BUILD") -llvmVersion $llvmVersion -msvcProductName $msvcProductName -platform 32 -configuration "Release" -target $target


# Test
# executeBuilder -tasks @("TEST") -llvmVersion $llvmVersion -msvcProductName $msvcProductName -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -patchInfos $patchInfos
# executeBuilder -tasks @("TEST") -llvmVersion $llvmVersion -msvcProductName $msvcProductName -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python -patchInfos $patchInfos
# executeBuilder -tasks @("PROJECT") -llvmVersion $llvmVersion -msvcProductName $msvcProductName -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -patchInfos $patchInfos
# executeBuilder -tasks @("PROJECT") -llvmVersion $llvmVersion -msvcProductName $msvcProductName -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python -patchInfos $patchInfos



[Console]::ReadKey()
