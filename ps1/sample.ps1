$launchPath = Split-Path $myInvocation.MyCommand.path -Parent
$builderShell = Join-Path $launchPath 'llvm-builder.ps1'

$cmake = Join-Path $launchPath "tools-latest-version/cmake-3.6.2-win64-x64/bin"
$msys2 = ( Join-Path $launchPath "tools-latest-version/msys64/mingw64/bin;" ) + ( Join-Path $launchPath "tools-latest-version/msys64/usr/bin" )
# $python = "c:/Python27"
# $gnu32 = "c:/cygwin-x86_64/tmp/llvm-build-shells/ps1/tools-latest-version/GnuWin32/bin"


$patchInfos = @( 
    @{ # llvm bug : fixed out of range
        applyLocation = "llvm/tools/clang/";
        absolutePath = ( Resolve-Path ( Join-Path $launchPath "../patch/bugfix000.patch" ) );
    }
    ,@{
        applyLocation = "llvm/";
        absolutePath = "c:/cygwin-x86_64/home/yaruopooner/.emacs.d/.emacs25/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch";
    }
)


# full task
# . $builderShell -tasks @("CHECKOUT", "PATCH", "PROJECT", "BUILD") -clangVersion 390 -msvcVersion 2015 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patchInfos -target "Clang libraries\libclang;Clang executables\clang-format"
# . $builderShell -tasks @("CHECKOUT", "PATCH", "PROJECT", "BUILD") -clangVersion 390 -msvcVersion 2013 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patchInfos -target "Clang libraries\libclang;Clang executables\clang-format"
# . $builderShell -tasks @("CHECKOUT", "PATCH") -clangVersion 380 -msvcVersion 2013 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patchInfos -target "Clang libraries\libclang;Clang executables\clang-format"
# . $builderShell -tasks @("PROJECT") -clangVersion 390 -msvcVersion 2013 -platform 32 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patchInfos -target "Clang libraries\libclang;Clang executables\clang-format"
# . $builderShell -tasks @("PROJECT", "BUILD") -clangVersion 390 -msvcVersion 2013 -platform 32 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patchInfos -target "Clang libraries\libclang;Clang executables\clang-format"

# . $builderShell -tasks @("CHECKOUT", "PATCH") -clangVersion 390 -patchInfos $patchInfos
. $builderShell -tasks @("PATCH") -clangVersion 390 -patchInfos $patchInfos
# . $builderShell -tasks @("PROJECT") -clangVersion 390 -msvcVersion 2013 -platform 64 -cmakePath $cmake -msys2Path $msys2
# . $builderShell -tasks @("PROJECT") -clangVersion 390 -msvcVersion 2013 -platform 32 -cmakePath $cmake -msys2Path $msys2
# . $builderShell -tasks @("BUILD") -clangVersion 390 -msvcVersion 2013 -platform 64 -configuration "Release" -target "Clang libraries\libclang"
# . $builderShell -tasks @("BUILD") -clangVersion 390 -msvcVersion 2013 -platform 32 -configuration "Release" -target "Clang libraries\libclang"
# . $builderShell -tasks @("BUILD") -clangVersion 390 -msvcVersion 2013 -platform 64 -configuration "Debug" -target "Clang libraries\libclang"
# . $builderShell -tasks @("BUILD") -clangVersion 390 -msvcVersion 2013 -platform 64 -configuration "RelWithDebInfo" -target "Clang libraries\libclang"

# . $builderShell -tasks @("CHECKOUT", "PATCH") -clangVersion 380 -patchInfos $patchInfos
# . $builderShell -tasks @("PROJECT") -clangVersion 380 -msvcVersion 2013 -platform 64 -cmakePath $cmake -msys2Path $msys2
# . $builderShell -tasks @("PROJECT") -clangVersion 380 -msvcVersion 2013 -platform 32 -cmakePath $cmake -msys2Path $msys2
# . $builderShell -tasks @("BUILD") -clangVersion 380 -msvcVersion 2013 -platform 64 -configuration "Release" -target "Clang libraries\libclang"
# . $builderShell -tasks @("BUILD") -clangVersion 380 -msvcVersion 2013 -platform 64 -configuration "Debug" -target "Clang libraries\libclang"
# . $builderShell -tasks @("BUILD") -clangVersion 380 -msvcVersion 2013 -platform 64 -configuration "RelWithDebInfo" -target "Clang libraries\libclang"
# . $builderShell -tasks @("BUILD") -clangVersion 380 -msvcVersion 2013 -platform 32 -configuration "Release" -target "Clang libraries\libclang"


# . $builderShell -tasks @("PROJECT") -clangVersion 380 -msvcVersion 2013 -platform 32 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patchInfos -target "Clang libraries\libclang;Clang executables\clang-format"
# . $builderShell -tasks @("PROJECT", "BUILD") -clangVersion 390 -msvcVersion 2013 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patchInfos -target "Clang libraries\libclang;Clang executables\clang-format"

# . $builderShell -tasks @("CHECKOUT", "PATCH", "PROJECT", "BUILD") -clangVersion 380 -msvcVersion 2013 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patchInfos -target "Clang libraries\libclang;Clang executables\clang-format"


# libclang only
# . $builderShell -tasks @("CHECKOUT", "PATCH") -clangVersion 390 -patchInfos $patchInfos
# . $builderShell -tasks @("PROJECT", "BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patchInfos -target "Clang libraries\libclang"
# . $builderShell -tasks @("PROJECT", "BUILD") -clangVersion 390 -msvcVersion 2013 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patchInfos -target "Clang libraries\libclang"
# . $builderShell -tasks @("BUILD") -clangVersion 390 -msvcVersion 2015 -platform 64 -configuration "Debug" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patchInfos -target "Clang libraries\libclang"
# . $builderShell -tasks @("PROJECT", "BUILD") -clangVersion 390 -msvcVersion 2015 -platform 32 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patchInfos -target "Clang libraries\libclang"

# . $builderShell -tasks @("CHECKOUT", "PROJECT", "BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2

# . $builderShell -tasks @("CHECKOUT") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# . $builderShell -tasks @("PROJECT") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# . $builderShell -tasks @("PROJECT") -clangVersion 390 -platform 32 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# . $builderShell -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# . $builderShell -tasks @("BUILD") -clangVersion 390 -platform 32 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# . $builderShell -tasks @("PROJECT", "BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# . $builderShell -tasks @("CHECKOUT", "PROJECT") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# . $builderShell -tasks @("PROJECT") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# . $builderShell -tasks @("PATCH") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patchInfos
# . $builderShell -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -target "Clang libraries\libclang"
# . $builderShell -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Debug" -cmakePath $cmake -msys2Path $msys2 -target "Clang libraries\libclang"
# . $builderShell -tasks @("PROJECT", "BUILD") -clangVersion 390 -platform 32 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# . $builderShell -tasks @("PROJECT", "BUILD") -clangVersion 390 -platform 32 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# . $builderShell -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -target "Clang libraries\libclang"
# . $builderShell -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -target "Clang libraries\libclang;Clang executables\clang-format"
# . $builderShell -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Debug" -cmakePath $cmake -msys2Path $msys2 -target "Clang libraries\libclang"
# . $builderShell -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -target "Clang executables\clang-format"



[Console]::ReadKey()
