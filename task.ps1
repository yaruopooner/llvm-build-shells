# . (@(Split-Path $myInvocation.MyCommand.path) + '\llvm-builder.ps1')
#$hoge = $myInvocation.MyCommand.path
#$hoge = Split-Path $hoge -Parent
#$hoge += '\llvm-builder.ps1'
$builderShell = Join-Path @(Split-Path $myInvocation.MyCommand.path -Parent) 'llvm-builder.ps1'

$cmake = "c:/cygwin-x86_64/tmp/cmake-3.0.2-win32-x86/bin"
$python = "c:/Python27"
$gnu32 = "c:/cygwin-x86_64/tmp/GnuWin32"


. $builderShell -targets @("SVN") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
. $builderShell -targets @("CMAKE", "MSBUILD") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
. $builderShell -targets @("CMAKE", "MSBUILD") -clangVersion 350 -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -targets @("MSBUILD") -clangVersion 350 -platform 64 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32
# . $builderShell -targets @("MSBUILD") -clangVersion 350 -platform 32 -configuration "Release" -cmakePath $cmake -pythonPath $python -gnu32Path $gnu32

# echo $hoge

# [Console]::ReadKey()
