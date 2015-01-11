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


# . $builderShell -targets @("SVN") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -targets @("CMAKE") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -targets @("CMAKE") -clangVersion 350 -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -targets @("MSBUILD") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -targets @("MSBUILD") -clangVersion 350 -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
. $builderShell -targets @("CMAKE", "MSBUILD") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -targets @("CMAKE", "MSBUILD") -clangVersion 350 -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -tasks @("MSBUILD") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -target "Clang libraries\libclang"
# . $builderShell -tasks @("MSBUILD") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -target "Clang libraries\libclang;Clang executables\clang-format"
# . $builderShell -tasks @("MSBUILD") -clangVersion 350 -platform 64 -configuration "Debug" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -target "Clang libraries\libclang"
# . $builderShell -tasks @("MSBUILD") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32 -target "Clang executables\clang-format"


# $cmake = "c:/cygwin-x86_64/tmp/cmake-3.0.2-win32-x86/bin"

# $exec = Join-Path $cmake "cmake.exe"
# $result = & $exec --version

# # "$result" -match "2`.[0-9]`.[0-9]"
# $judge = "$result" -match "3`.[0-9]`.[0-9]"

# if ( $judge )
# {
#     echo "true"
# }
# else
# {
#     echo "false"
# }


[Console]::ReadKey()
