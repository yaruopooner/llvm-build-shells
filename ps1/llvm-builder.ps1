Param( $tasks = @(), $clangVersion, $workingDirectory = ".", $msvcVersion = 2013, $target, $platform = 64, $configuration = "Release", $additionalProperties, $cmakePath, $pythonPath, $gnu32Path, $patchInfos )

# $tasks = @("CHECKOUT", "PATCH", "PROJECT", "BUILD")
# $tasks = @("CHECKOUT", "PROJECT", "BUILD")
# $tasks = @("CHECKOUT", "PROJECT")
# $tasks = @("CHECKOUT")
# $tasks = @("PROJECT")

# $patchInfos = @( 
#     @{
#         # apply a patch to relative path from checkout root dir .
#         applyLocation = "llvm/";
#         # patch absolute path
#         absolutePath = "ac-clang/clang-server/patch/invalidate-mmap.patch";
#     },
#     @{
#         applyLocation = "llvm/tools/clang/";
#         absolutePath = "ac-clang/clang-server/patch/libclang-x86_64.patch";
#     }
# )


# $clangVersion = 350
# $platform = 32



# $cmakePath = "c:/cygwin-x86_64/tmp/cmake-3.0.2-win32-x86/bin"
# $pythonPath = "c:/Python27"
# $gnu32Path = "c:/cygwin-x86_64/tmp/GnuWin32"


$LLVMBuildEnv = @{
    ClangBuildVersion = "trunk";
    CheckoutRepository = "trunk";
    WorkingDir = ".";
    CheckoutRootDir = "";
    BuildDir = $null;

    SVN = @{
    };

    CMAKE = @{
        ExecPath = "";
        PythonPath = "";
        MSVCVersion = "12 2013";
        Platform = "Win64";
        PlatformDir = "msvc-64";
        BuildDir = "build";
        GeneratorName = $null;
        CommandLine = $null;

        CONST = @{
            MSVC = @{
                2015 = "14 2015";
                2013 = "12 2013";
                2012 = "11 2012";
                2010 = "10 2010";
            };
            PLATFORM = @{
                32 = @{
                    Name = $null;
                    Directory = "msvc-32";
                };
                64 = @{
                    Name = "Win64";
                    Directory = "msvc-64";
                };
            };
        };

        CONST200 = @{
            MSVC = @{
                2013 = "12";
                2012 = "11";
                2010 = "10";
            };
            PLATFORM = @{
                32 = @{
                    Name = $null;
                    Directory = "msvc-32";
                };
                64 = @{
                    Name = "Win64";
                    Directory = "msvc-64";
                };
            };
        };
    };

    BUILD = @{
        Gnu32Path = "";
        MSVCVersion  = "";
        Target = "";
        Platform = "x64";
        PlatformDir = "msvc-64";
        Configuration = "Release";
        TargetNameSuffix = "-x86_64";
        AdditionalProperties = "";
        VsCmdPrompt = "";
        VsCmdPromptArg = "amd64";
        CommandLine = "";

        CONST = @{
            MSVC = @{
                2015 = "VS140COMNTOOLS";
                2013 = "VS120COMNTOOLS";
                2012 = "VS110COMNTOOLS";
                2010 = "VS100COMNTOOLS";
            };
            PLATFORM = @{
                32 = @{
                    Name = "Win32";
                    Directory = "msvc-32";
                    TargetNameSuffix = "-x86_32";
                    VsCmdPromptArg = "x86";
                }
                64 = @{
                    Name = "x64";
                    Directory = "msvc-64";
                    TargetNameSuffix = "-x86_64";
                    VsCmdPromptArg = "amd64";
                };
            };
        };
    }
}


# utilities

function pause()
{
    echo 'Press any key'
    [Console]::ReadKey()
}


function prependToEnvPath( $path )
{
    if ( $path -ne $null )
    {
        $env:PATH = $path + ";" + $env:PATH
    }
}

function appendToEnvPath( $path )
{
    if ( $path -ne $null )
    {
        $env:PATH += ";" + $path
    }
}

function syncNewDirectory( $targetPath )
{
    if ( Test-Path $targetPath )
    {
        echo "remove old dir = $targetPath"
        Remove-Item -path $targetPath -recurse -force
    }
    while ( Test-Path $targetPath )
    {
        Start-Sleep -m 500
    }
    New-Item -name $targetPath -type directory
}

function importScriptEnvVariables( $script, $scriptArg )
{
    $temp_file = [IO.Path]::GetTempFileName()

    cmd /c " `"$script`" $scriptArg && set > `"$temp_file`" "

    Get-Content $temp_file | Foreach-Object {
        if( $_ -match "^(.*?)=(.*)$" )
        { 
            Set-Content "env:\$($matches[1])" $matches[2]
        } 
    }

    Remove-Item $temp_file
}



# common funcs

function messageHelp()
{
    echo '$clangVersion designates llvm version number (e.g 33, 34, 35...)'
    echo 'When $clangVersion is empty that will assign trunk.'
    echo '$workingDirectory is working directory.'
    echo 'When $workingDirectory is empty that will assign /tmp.'
    echo 'Cautions! When a checkout-path exist a same name directory, it deletes and creates. '
}



function setupCommonVariables()
{
    # common

    if ( $clangVersion -ne $null )
    {
        $LLVMBuildEnv.ClangBuildVersion = $clangVersion
        $LLVMBuildEnv.CheckoutRepository = "tags/RELEASE_$clangVersion/final"
    }
    else
    {
        $LLVMBuildEnv.ClangBuildVersion = "trunk"
        $LLVMBuildEnv.CheckoutRepository = "trunk"
    }

    $LLVMBuildEnv.CheckoutRootDir = "clang-" + $LLVMBuildEnv.ClangBuildVersion
    $LLVMBuildEnv.WorkingDir = "."

    if ( $workingDirectory -ne $null )
    {
        $LLVMBuildEnv.WorkingDir = $workingDirectory
    }

    if ( $LLVMBuildEnv.BuildDir -eq $null )
    {
        $LLVMBuildEnv.BuildDir = "build"
    }
}

function executeCommon()
{
}


# SVN funcs


function messageCheckoutEnvironment()
{
    echo "clang build target  = " + $LLVMBuildEnv.ClangBuildVersion
    echo "checkout repository = " + $LLVMBuildEnv.CheckoutRepository
    echo "checkout root directory  = " + $LLVMBuildEnv.CheckoutRootDir
    echo "working directory   = " + $LLVMBuildEnv.WorkingDir
}

function setupCheckoutVariables()
{
}

function executeCheckoutBySVN()
{
    pushd $LLVMBuildEnv.WorkingDir

    $checkout_root_dir = $LLVMBuildEnv.CheckoutRootDir

    syncNewDirectory -targetPath $checkout_root_dir


    # proxy がある場合は ~/.subversion/servers に host と port を指定
    $cmd = "svn"
    $checkout_infos = @(
        @{
            location = $checkout_root_dir;
            repository_url = "http://llvm.org/svn/llvm-project/llvm/" + $LLVMBuildEnv.CheckoutRepository;
            checkout_dir = "llvm"
        }, 
        @{
            location = Join-Path $checkout_root_dir "llvm/tools";
            repository_url = "http://llvm.org/svn/llvm-project/cfe/" + $LLVMBuildEnv.CheckoutRepository;
            checkout_dir = "clang";
        }, 
        @{
            location = Join-Path $checkout_root_dir "llvm/tools/clang/tools";
            repository_url = "http://llvm.org/svn/llvm-project/clang-tools-extra/" + $LLVMBuildEnv.CheckoutRepository;
            checkout_dir = "extra";
        }, 
        @{
            location = Join-Path $checkout_root_dir "llvm/projects";
            repository_url = "http://llvm.org/svn/llvm-project/compiler-rt/" + $LLVMBuildEnv.CheckoutRepository;
            checkout_dir = "compiler-rt";
        }
    )

    foreach ( $info in $checkout_infos )
    {
        pushd $info.location
        $cmd_args = @("co", "--force", $info.repository_url, $info.checkout_dir)
        & $cmd $cmd_args
        # echo $cmd_args
        popd
    }

    popd
}


# patch funcs

function setupPatchVariables()
{
}

function executePatchBySVN()
{
    $checkout_root_dir = $LLVMBuildEnv.CheckoutRootDir
    pushd $checkout_root_dir

    $cmd = "svn"
    
    foreach ( $info in $patchInfos )
    {
        pushd $info.applyLocation
        $cmd_args = @("patch", $info.absolutePath)
        & $cmd $cmd_args
        popd
    }

    popd
}



# cmake funcs

function setupCMakeVariables()
{
    $LLVMBuildEnv.CMAKE.ExecPath = $cmakePath
    $LLVMBuildEnv.CMAKE.PythonPath = $pythonPath

    $cmd = Join-Path $cmakePath "cmake"
    $result = & $cmd @("--version")
    $old = "$result" -match "2`.[0-9]`.[0-9]"

    if ( $old )
    {
        echo "cmake version 3.0 under"
        $const_vars = $LLVMBuildEnv.CMAKE.CONST200
    }
    else
    {
        echo "cmake version 3.0 upper"
        # $const_vars = $LLVMBuildEnv.CMAKE.CONST200
        $const_vars = $LLVMBuildEnv.CMAKE.CONST
    }

    if ( $msvcVersion -ne $null )
    {
        $LLVMBuildEnv.CMAKE.MSVCVersion = $const_vars.MSVC[ $msvcVersion ]
    }

    if ( $platform -ne $null )
    {
        $LLVMBuildEnv.CMAKE.GeneratorName = "Visual Studio " + $LLVMBuildEnv.CMAKE.MSVCVersion

        $platform_option = $const_vars.PLATFORM[ $platform ].Name
        if ( $platform_option -ne $null )
        {
            $LLVMBuildEnv.CMAKE.GeneratorName += " " + $platform_option
        }

        $LLVMBuildEnv.CMAKE.PlatformDir = $const_vars.PLATFORM[ $platform ].Directory
    }
}


function executeCMake()
{
    prependToEnvPath -path $LLVMBuildEnv.CMAKE.ExecPath
    prependToEnvPath -path $LLVMBuildEnv.CMAKE.PythonPath

    pushd $LLVMBuildEnv.WorkingDir
    cd $LLVMBuildEnv.CheckoutRootDir

    # local vars
    $build_dir = $LLVMBuildEnv.BuildDir
    $platform_dir = $LLVMBuildEnv.CMAKE.PlatformDir

    if ( !( Test-Path $build_dir ) )
    {
        New-Item -name $build_dir -type directory
    }
    cd $build_dir

    syncNewDirectory -targetPath $platform_dir

    cd $platform_dir

    $cmd = "cmake"
    $cmd_args = @("-G", $LLVMBuildEnv.CMAKE.GeneratorName, "..\..\llvm")

    & $cmd $cmd_args

    popd
}



# build funcs


function setupBuildVariables()
{
    $LLVMBuildEnv.BUILD.Gnu32Path = $gnu32Path

    # local vars
    $const_vars = $LLVMBuildEnv.BUILD.CONST

    if ( $msvcVersion -ne $null )
    {
        $LLVMBuildEnv.BUILD.MSVCVersion = $const_vars.MSVC[ $msvcVersion ]
    }

    if ( $target -ne $null )
    {
        $LLVMBuildEnv.BUILD.Target = "/t:" + $target
    }
    
    if ( $platform -ne $null )
    {
        $LLVMBuildEnv.BUILD.Platform = $const_vars.PLATFORM[ $platform ].Name
        $LLVMBuildEnv.BUILD.PlatformDir = $const_vars.PLATFORM[ $platform ].Directory
        $LLVMBuildEnv.BUILD.TargetNameSuffix = $const_vars.PLATFORM[ $platform ].TargetNameSuffix
        $LLVMBuildEnv.BUILD.VsCmdPromptArg = $const_vars.PLATFORM[ $platform ].VsCmdPromptArg
    }

    if ( $configuration -ne $null )
    {
        $LLVMBuildEnv.BUILD.Configuration = $configuration
    }

    if ( $additionalProperties -ne $null )
    {
        $LLVMBuildEnv.BUILD.AdditionalProperties = ";" + $additionalProperties
    }
    

    # $LLVMBuildEnv.BUILD.VsCmdPrompt = [Environment]::GetEnvironmentVariable($LLVMBuildEnv.BUILD.MSVCVersion, 'Machine')
    $env_var = "env:" + $LLVMBuildEnv.BUILD.MSVCVersion
    $LLVMBuildEnv.BUILD.VsCmdPrompt = Get-Content $env_var
    $LLVMBuildEnv.BUILD.VsCmdPrompt += "../../VC/vcvarsall.bat"
}

function executeBuild()
{
    prependToEnvPath -path $LLVMBuildEnv.BUILD.Gnu32Path

    # $script = $LLVMBuildEnv.BUILD.VsCmdPrompt
    # $scriptArg = $LLVMBuildEnv.BUILD.VsCmdPromptArg
    importScriptEnvVariables -script $LLVMBuildEnv.BUILD.VsCmdPrompt -scriptArg $LLVMBuildEnv.BUILD.VsCmdPromptArg

    pushd $LLVMBuildEnv.WorkingDir
    cd $LLVMBuildEnv.CheckoutRootDir
    cd $LLVMBuildEnv.BuildDir
    cd $LLVMBuildEnv.BUILD.PlatformDir

    $cmd = "msbuild"
    $target = $LLVMBuildEnv.BUILD.Target
    $properties = "/p:Platform=" + $LLVMBuildEnv.BUILD.Platform + ";Configuration=" + $LLVMBuildEnv.BUILD.Configuration + $LLVMBuildEnv.BUILD.AdditionalProperties
    $cmd_args = @("LLVM.sln", $target, $properties, "/maxcpucount", "/fileLogger")

    & $cmd $cmd_args

    popd
}


$phase_infos = @{
    CHECKOUT = @{
        setup = {setupCheckoutVariables};
        execute = {executeCheckoutBySVN};
    };
    PATCH = @{
        setup = {setupPatchVariables};
        execute = {executePatchBySVN};
    };
    PROJECT = @{
        setup = {setupCMakeVariables};
        execute = {executeCMake};
    };
    BUILD = @{
        setup = {setupBuildVariables};
        execute = {executeBuild};
    };
}




function setupVariables()
{
    setupCommonVariables

    foreach ( $task in $tasks )
    {
        $phase = $phase_infos[ $task ]
        if ( $phase -ne $null )
        {
            & $phase.setup
            # Invoke-Command -scriptblock $phase.setup
        }
    }
}

function executeTasks()
{
    executeCommon

    foreach ( $task in $tasks )
    {
        $phase = $phase_infos[ $task ]
        if ( $phase -ne $null )
        {
            & $phase.execute
        }
    }
}



setupVariables
executeTasks


# echo $LLVMBuildEnv
# echo $LLVMBuildEnv.SVN
# echo $LLVMBuildEnv.CMAKE
# echo $LLVMBuildEnv.BUILD
# echo $env:Path


# pause

