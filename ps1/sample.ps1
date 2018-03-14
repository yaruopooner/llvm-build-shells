$launchPath = Split-Path $myInvocation.MyCommand.path -Parent
$builderShell = Join-Path $launchPath 'llvm-builder.ps1'

$cmake = Join-Path $launchPath "tools-latest-version/cmake-3.10.2-win64-x64/bin"
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

$llvmVersion = 600
# $llvmVersion = 500
$msvcVersion = 2017
# $msvcVersion = 2015


# LLVM ALL Build (full task)
executeBuilder -tasks @("CHECKOUT", "PATCH", "PROJECT", "BUILD") -llvmVersion $llvmVersion -msvcVersion $msvcVersion -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -patchInfos $patchInfos


# LLVM Parts Build (full task)
# $target = "Clang libraries\libclang;Clang executables\clang-format"
# executeBuilder -tasks @("CHECKOUT", "PATCH", "PROJECT", "BUILD") -llvmVersion $llvmVersion -msvcVersion $msvcVersion -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -patchInfos $patchInfos -target $target


# LLVM Parts Build (parts task)
# $target = "Clang libraries\libclang;Clang executables\clang-format"
# executeBuilder -tasks @("CHECKOUT", "PATCH") -llvmVersion $llvmVersion -patchInfos $patchInfos
# executeBuilder -tasks @("PROJECT", "BUILD") -llvmVersion $llvmVersion -msvcVersion $msvcVersion -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -target $target
# executeBuilder -tasks @("PROJECT", "BUILD") -llvmVersion $llvmVersion -msvcVersion $msvcVersion -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python


# LLVM Parts Build (single task)
# $target = "Clang libraries\libclang;Clang executables\clang-format"
# executeBuilder -tasks @("CHECKOUT") -llvmVersion $llvmVersion
# executeBuilder -tasks @("PATCH") -llvmVersion $llvmVersion -patchInfos $patchInfos
# executeBuilder -tasks @("PROJECT") -llvmVersion $llvmVersion -msvcVersion $msvcVersion -platform 64 -cmakePath $cmake -pythonPath $python
# executeBuilder -tasks @("PROJECT") -llvmVersion $llvmVersion -msvcVersion $msvcVersion -platform 32 -cmakePath $cmake -pythonPath $python
# executeBuilder -tasks @("BUILD") -llvmVersion $llvmVersion -msvcVersion $msvcVersion -platform 64 -configuration "Release" -target $target
# executeBuilder -tasks @("BUILD") -llvmVersion $llvmVersion -msvcVersion $msvcVersion -platform 32 -configuration "Release" -target $target





[Console]::ReadKey()
