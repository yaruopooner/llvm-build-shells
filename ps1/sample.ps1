$launchPath= Split-Path $myInvocation.MyCommand.path -Parent
$builderShell = Join-Path $launchPath 'llvm-builder.ps1'

# $cmake = "./tools-latest-version/cmake-2.8.12.2-win32-x86/bin"
# $cmake = "./tools-latest-version/cmake-3.0.2-win32-x86/bin"
# $cmake = "./tools-latest-version/cmake-3.1.3-win32-x86/bin"
# $cmake = "./tools-latest-version/cmake-3.3.1-win32-x86/bin"
$cmake = Join-Path $launchPath "tools-latest-version/cmake-3.6.2-win64-x64/bin"
$python = "c:/Python27"
$gnu32 = "c:/cygwin-x86_64/tmp/GnuWin32"


$patchInfos = @( 
    @{
        applyLocation = "llvm/";
        # absolutePath = "c:/cygwin-x86_64/yaruopooner/.emacs.d/.emacs25/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch";
        absolutePath = "c:/cygwin-x86_64/root/.emacs.d/.emacs25/packages/user/ac-clang/clang-server/patch/invalidate-mmap.patch";
    }
)


# full task
# . $builderShell -tasks @("CHECKOUT", "PATCH", "PROJECT", "BUILD") -clangVersion 390 -msvcVersion 2015 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -patchInfos $patchInfos -target "Clang libraries\libclang;Clang executables\clang-format"
. $builderShell -tasks @("CHECKOUT", "PATCH", "PROJECT", "BUILD") -clangVersion 390 -msvcVersion 2013 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -patchInfos $patchInfos -target "Clang libraries\libclang;Clang executables\clang-format"

# libclang only
# . $builderShell -tasks @("CHECKOUT", "PATCH") -clangVersion 390 -patchInfos $patchInfos
# . $builderShell -tasks @("PROJECT", "BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -patchInfos $patchInfos -target "Clang libraries\libclang"
# . $builderShell -tasks @("PROJECT", "BUILD") -clangVersion 390 -msvcVersion 2013 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -patchInfos $patchInfos -target "Clang libraries\libclang"
# . $builderShell -tasks @("BUILD") -clangVersion 390 -msvcVersion 2015 -platform 64 -configuration "Debug" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -patchInfos $patchInfos -target "Clang libraries\libclang"
# . $builderShell -tasks @("PROJECT", "BUILD") -clangVersion 390 -msvcVersion 2015 -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -patchInfos $patchInfos -target "Clang libraries\libclang"

# . $builderShell -tasks @("CHECKOUT", "PROJECT", "BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32

# . $builderShell -tasks @("CHECKOUT") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("PROJECT") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("PROJECT") -clangVersion 390 -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("BUILD") -clangVersion 390 -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("PROJECT", "BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("CHECKOUT", "PROJECT") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("PROJECT") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("PATCH") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -patchInfos $patchInfos
# . $builderShell -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -target "Clang libraries\libclang"
# . $builderShell -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Debug" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -target "Clang libraries\libclang"
# . $builderShell -tasks @("PROJECT", "BUILD") -clangVersion 390 -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("PROJECT", "BUILD") -clangVersion 390 -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -target "Clang libraries\libclang"
# . $builderShell -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -target "Clang libraries\libclang;Clang executables\clang-format"
# . $builderShell -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Debug" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -target "Clang libraries\libclang"
# . $builderShell -tasks @("BUILD") -clangVersion 390 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -target "Clang executables\clang-format"



[Console]::ReadKey()
