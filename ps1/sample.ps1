# . (@(Split-Path $myInvocation.MyCommand.path) + '\llvm-builder.ps1')
#$hoge = $myInvocation.MyCommand.path
#$hoge = Split-Path $hoge -Parent
#$hoge += '\llvm-builder.ps1'
$builderShell = Join-Path @(Split-Path $myInvocation.MyCommand.path -Parent) 'llvm-builder.ps1'

# $cmake = "c:/cygwin-x86_64/tmp/cmake-2.8.12.2-win32-x86/bin"
# $cmake = "c:/cygwin-x86_64/tmp/cmake-3.0.2-win32-x86/bin"
$cmake = "c:/cygwin-x86_64/tmp/cmake-3.1.0-win32-x86/bin"
$python = "c:/Python27"
$gnu32 = "c:/cygwin-x86_64/tmp/GnuWin32"


$patchInfos = @( 
    @{
        applyLocation = "llvm/";
        absolutePath = "c:/cygwin-x86_64/tmp/ac-clang/clang-server/patch/invalidate-mmap.patch";
    }
)


# full task
# . $builderShell -tasks @("CHECKOUT", "PATCH", "PROJECT", "BUILD") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -patchInfos $patchInfos

# libclang only
. $builderShell -tasks @("CHECKOUT", "PATCH", "PROJECT", "BUILD") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -patchInfos $patchInfos -target "Clang libraries\libclang"

# . $builderShell -tasks @("CHECKOUT", "PROJECT", "BUILD") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32

# . $builderShell -tasks @("CHECKOUT") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("PROJECT") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("PROJECT") -clangVersion 350 -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("BUILD") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("BUILD") -clangVersion 350 -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("PROJECT", "BUILD") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("CHECKOUT", "PROJECT") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("PROJECT") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("PATCH") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -patchInfos $patchInfos
# . $builderShell -tasks @("BUILD") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -target "Clang libraries\libclang"
# . $builderShell -tasks @("BUILD") -clangVersion 350 -platform 64 -configuration "Debug" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -target "Clang libraries\libclang"
# . $builderShell -tasks @("PROJECT", "BUILD") -clangVersion 350 -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("PROJECT", "BUILD") -clangVersion 350 -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("BUILD") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -target "Clang libraries\libclang"
# . $builderShell -tasks @("BUILD") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -target "Clang libraries\libclang;Clang executables\clang-format"
# . $builderShell -tasks @("BUILD") -clangVersion 350 -platform 64 -configuration "Debug" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -target "Clang libraries\libclang"
# . $builderShell -tasks @("BUILD") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -target "Clang executables\clang-format"



[Console]::ReadKey()
