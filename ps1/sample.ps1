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
        absolutePath = "c:/cygwin-x86_64/root/.emacs.d/.emacs25/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch";
    }
)

. $builderShell


# full task
# executeBuilder -tasks @("CHECKOUT", "PATCH", "PROJECT", "BUILD") -clangVersion 390 -msvcVersion 2015 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patches -target "Clang libraries\libclang;Clang executables\clang-format"
# executeBuilder -tasks @("CHECKOUT", "PATCH", "PROJECT", "BUILD") -clangVersion 390 -msvcVersion 2013 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patches -target "Clang libraries\libclang;Clang executables\clang-format"
# executeBuilder -tasks @("CHECKOUT", "PATCH") -clangVersion 380 -msvcVersion 2013 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patches -target "Clang libraries\libclang;Clang executables\clang-format"
# executeBuilder -tasks @("PROJECT") -clangVersion 390 -msvcVersion 2013 -platform 32 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patches -target "Clang libraries\libclang;Clang executables\clang-format"
# executeBuilder -tasks @("PROJECT", "BUILD") -clangVersion 390 -msvcVersion 2013 -platform 32 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patches -target "Clang libraries\libclang;Clang executables\clang-format"


executeBuilder -tasks @("CHECKOUT", "PATCH") -clangVersion 390 -patchInfos $patchInfos
# executeBuilder -tasks @("PATCH") -clangVersion 390 -patchInfos $patchInfos
executeBuilder -tasks @("PROJECT") -clangVersion 390 -msvcVersion 2013 -platform 64 -cmakePath $cmake -msys2Path $msys2
executeBuilder -tasks @("PROJECT") -clangVersion 390 -msvcVersion 2013 -platform 32 -cmakePath $cmake -msys2Path $msys2
executeBuilder -tasks @("BUILD") -clangVersion 390 -msvcVersion 2013 -platform 64 -configuration "Release" -target "Clang libraries\libclang"
executeBuilder -tasks @("BUILD") -clangVersion 390 -msvcVersion 2013 -platform 32 -configuration "Release" -target "Clang libraries\libclang"
# executeBuilder -tasks @("BUILD") -clangVersion 390 -msvcVersion 2013 -platform 64 -configuration "Debug" -target "Clang libraries\libclang"
# executeBuilder -tasks @("BUILD") -clangVersion 390 -msvcVersion 2013 -platform 64 -configuration "RelWithDebInfo" -target "Clang libraries\libclang"

executeBuilder -tasks @("CHECKOUT", "PATCH") -clangVersion 380 -patchInfos $patchInfos
# executeBuilder -tasks @("PATCH") -clangVersion 380 -patchInfos $patchInfos
executeBuilder -tasks @("PROJECT") -clangVersion 380 -msvcVersion 2013 -platform 64 -cmakePath $cmake -msys2Path $msys2
executeBuilder -tasks @("PROJECT") -clangVersion 380 -msvcVersion 2013 -platform 32 -cmakePath $cmake -msys2Path $msys2
executeBuilder -tasks @("BUILD") -clangVersion 380 -msvcVersion 2013 -platform 64 -configuration "Release" -target "Clang libraries\libclang"
executeBuilder -tasks @("BUILD") -clangVersion 380 -msvcVersion 2013 -platform 32 -configuration "Release" -target "Clang libraries\libclang"
# executeBuilder -tasks @("BUILD") -clangVersion 380 -msvcVersion 2013 -platform 64 -configuration "Debug" -target "Clang libraries\libclang"
# executeBuilder -tasks @("BUILD") -clangVersion 380 -msvcVersion 2013 -platform 64 -configuration "RelWithDebInfo" -target "Clang libraries\libclang"


# executeBuilder -tasks @("PROJECT") -clangVersion 380 -msvcVersion 2013 -platform 32 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patches -target "Clang libraries\libclang;Clang executables\clang-format"
# executeBuilder -tasks @("PROJECT", "BUILD") -clangVersion 390 -msvcVersion 2013 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patches -target "Clang libraries\libclang;Clang executables\clang-format"

# executeBuilder -tasks @("CHECKOUT", "PATCH", "PROJECT", "BUILD") -clangVersion 380 -msvcVersion 2013 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patches -target "Clang libraries\libclang;Clang executables\clang-format"


# libclang only
# executeBuilder -tasks @("CHECKOUT", "PATCH") -clangVersion 390 -patchInfos $patches
# executeBuilder -tasks @("PROJECT", "BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patches -target "Clang libraries\libclang"
# executeBuilder -tasks @("PROJECT", "BUILD") -clangVersion 390 -msvcVersion 2013 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patches -target "Clang libraries\libclang"
# executeBuilder -tasks @("BUILD") -clangVersion 390 -msvcVersion 2015 -platform 64 -configuration "Debug" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patches -target "Clang libraries\libclang"
# executeBuilder -tasks @("PROJECT", "BUILD") -clangVersion 390 -msvcVersion 2015 -platform 32 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patches -target "Clang libraries\libclang"

# executeBuilder -tasks @("CHECKOUT", "PROJECT", "BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2

# executeBuilder -tasks @("CHECKOUT") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# executeBuilder -tasks @("PROJECT") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# executeBuilder -tasks @("PROJECT") -clangVersion 390 -platform 32 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# executeBuilder -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# executeBuilder -tasks @("BUILD") -clangVersion 390 -platform 32 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# executeBuilder -tasks @("PROJECT", "BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# executeBuilder -tasks @("CHECKOUT", "PROJECT") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# executeBuilder -tasks @("PROJECT") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# executeBuilder -tasks @("PATCH") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -patchInfos $patches
# executeBuilder -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -target "Clang libraries\libclang"
# executeBuilder -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Debug" -cmakePath $cmake -msys2Path $msys2 -target "Clang libraries\libclang"
# executeBuilder -tasks @("PROJECT", "BUILD") -clangVersion 390 -platform 32 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# executeBuilder -tasks @("PROJECT", "BUILD") -clangVersion 390 -platform 32 -configuration "Release" -cmakePath $cmake -msys2Path $msys2
# executeBuilder -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -target "Clang libraries\libclang"
# executeBuilder -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -target "Clang libraries\libclang;Clang executables\clang-format"
# executeBuilder -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Debug" -cmakePath $cmake -msys2Path $msys2 -target "Clang libraries\libclang"
# executeBuilder -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -msys2Path $msys2 -target "Clang executables\clang-format"



[Console]::ReadKey()
