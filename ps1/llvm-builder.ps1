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
        PlatformDir = "msvc2015-64";
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
                };
                64 = @{
                    Name = "Win64";
                };
            };
        };
    };

    BUILD = @{
        Gnu32Path = "";
        MSVCVersion  = "";
        Target = "";
        Platform = "x64";
        PlatformDir = "msvc2015-64";
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
                    TargetNameSuffix = "-x86_32";
                    VsCmdPromptArg = "x86";
                }
                64 = @{
                    Name = "x64";
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
    Write-Host 'Press any key'
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
    # if ( Test-Path $targetPath )
    # {
    #     Write-Host "remove old dir = $targetPath"
    #     Remove-Item -path $targetPath -recurse -force
    # }
    if ( Test-Path $targetPath )
    {
        $renamed_path = $targetPath
        do
        {
            $renamed_path += "_"
        }
        while ( Test-Path $renamed_path )

        Rename-Item -path $targetPath -newName $renamed_path -force
        # Rename-Item -path $targetPath -newName $renamed_path

        Write-Host "rename & remove old dir = $targetPath > $renamed_path"
        Remove-Item -path $renamed_path -recurse -force
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

function getPlatformDirectoryName()
{
    # "msvc{0}-{1}-{2}" -f $msvcVersion, $platform, $configuration
    "msvc${msvcVersion}-${platform}"
}



# common funcs

function messageHelp()
{
    Write-Host '$clangVersion designates llvm version number (e.g 33, 34, 35...)'
    Write-Host 'When $clangVersion is empty that will assign trunk.'
    Write-Host '$workingDirectory is working directory.'
    Write-Host 'When $workingDirectory is empty that will assign /tmp.'
    Write-Host 'Cautions! When a checkout-path exist a same name directory, it deletes and creates. '
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
    Write-Host "clang build target  = " + $LLVMBuildEnv.ClangBuildVersion
    Write-Host "checkout repository = " + $LLVMBuildEnv.CheckoutRepository
    Write-Host "checkout root directory  = " + $LLVMBuildEnv.CheckoutRootDir
    Write-Host "working directory   = " + $LLVMBuildEnv.WorkingDir
}

function setupCheckoutVariables( [ref]$result )
{
    $result.value = $true
}

function executeCheckoutBySVN( [ref]$result )
{
    pushd $LLVMBuildEnv.WorkingDir

    $checkout_root_dir = $LLVMBuildEnv.CheckoutRootDir

    syncNewDirectory -targetPath $checkout_root_dir


    # proxy がある場合は ~/.subversion/servers に host と port を指定
    $cmd = "svn"
    $checkout_infos = @(
        # LLVM
        @{
            location = $checkout_root_dir;
            repository_url = "http://llvm.org/svn/llvm-project/llvm/" + $LLVMBuildEnv.CheckoutRepository;
            checkout_dir = "llvm"
        }, 
        # Clang
        @{
            location = Join-Path $checkout_root_dir "llvm/tools";
            repository_url = "http://llvm.org/svn/llvm-project/cfe/" + $LLVMBuildEnv.CheckoutRepository;
            checkout_dir = "clang";
        }, 
        # Clang tools
        @{
            location = Join-Path $checkout_root_dir "llvm/tools/clang/tools";
            repository_url = "http://llvm.org/svn/llvm-project/clang-tools-extra/" + $LLVMBuildEnv.CheckoutRepository;
            checkout_dir = "extra";
        }, 
        # Compiler-RT (required to build the sanitizers) [Optional]:
        @{
            location = Join-Path $checkout_root_dir "llvm/projects";
            repository_url = "http://llvm.org/svn/llvm-project/compiler-rt/" + $LLVMBuildEnv.CheckoutRepository;
            checkout_dir = "compiler-rt";
        }
        # Libomp (required for OpenMP support) [Optional]
        @{
            location = Join-Path $checkout_root_dir "llvm/projects";
            repository_url = "http://llvm.org/svn/llvm-project/openmp/" + $LLVMBuildEnv.CheckoutRepository;
            checkout_dir = "openmp";
        }
        # libcxx [Optional]
        @{
            location = Join-Path $checkout_root_dir "llvm/projects";
            repository_url = "http://llvm.org/svn/llvm-project/libcxx/" + $LLVMBuildEnv.CheckoutRepository;
            checkout_dir = "libcxx";
        }
        # libcxxabi [Optional]
        @{
            location = Join-Path $checkout_root_dir "llvm/projects";
            repository_url = "http://llvm.org/svn/llvm-project/libcxxabi/" + $LLVMBuildEnv.CheckoutRepository;
            checkout_dir = "libcxxabi";
        }
        # Test Suite Source Code [Optional]
        # @{
        #     location = Join-Path $checkout_root_dir "llvm/projects";
        #     repository_url = "http://llvm.org/svn/llvm-project/test-suite/" + $LLVMBuildEnv.CheckoutRepository;
        #     checkout_dir = "test-suite";
        # }
    )

    foreach ( $info in $checkout_infos )
    {
        pushd $info.location
        $cmd_args = @("co", "--force", $info.repository_url, $info.checkout_dir)
        & $cmd $cmd_args
        # Write-Host $cmd_args
        popd
    }

    popd

    $result.value = $true
}


# patch funcs

function setupPatchVariables( [ref]$result )
{
    $result.value = $true
}

function executePatchBySVN( [ref]$result )
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

    $result.value = $true
}



# cmake funcs

function setupCMakeVariables( [ref]$result )
{
    $LLVMBuildEnv.CMAKE.ExecPath = $cmakePath
    $LLVMBuildEnv.CMAKE.PythonPath = $pythonPath

    $cmd = Join-Path $cmakePath "cmake"
    $cmd_result = & $cmd @( "--version" )
    $regex = [regex]"\d+`.\d+`.\d+"
    $regex_result = $regex.Matches( $cmd_result )
    $version = $regex_result.value -split "\."
    $major = [int]$version[0]
    $minor = [int]$version[1]
    $maintenance = [int]$version[2]

    if ( ($major -gt 3) -or ( ($major -eq 3) -and ( ($minor -gt 4) -or ( ($minor -eq 4) -and ($maintenance -ge 3) ) ) ) )
    {
        Write-Host "cmake version 3.0 upper"
        $const_vars = $LLVMBuildEnv.CMAKE.CONST
    }
    else
    {
        Write-Host "current cmake version is $cmd_result"
        Write-Host "cmake version 3.4.3 under"
        Write-Host "require version 3.4.3 or higher version"
        $result.value = $false

        return
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

        $LLVMBuildEnv.CMAKE.PlatformDir = getPlatformDirectoryName
    }

    $result.value = $true
}


function executeCMake( [ref]$result )
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

    $result.value = $true
}



# build funcs


function setupBuildVariables( [ref]$result )
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
        $LLVMBuildEnv.BUILD.PlatformDir = getPlatformDirectoryName
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
    $LLVMBuildEnv.BUILD.VsCmdPrompt = Get-Content $env_var -ErrorAction Ignore
    # check exit code
    if ( -not $? )
    {
        Write-Host "not detect Microsoft Visual Studio ${msvcVersion}"
        $result.value = $false

        return
    }

    $LLVMBuildEnv.BUILD.VsCmdPrompt += "../../VC/vcvarsall.bat"

    $result.value = $true
}

function executeBuild( [ref]$result )
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

    $result.value = $true
}


$phase_infos = @{
    CHECKOUT = @{
        setup = {
            param( [ref]$result )
            setupCheckoutVariables -result $result
        };
        execute = {
            param( [ref]$result )
            executeCheckoutBySVN -result $result
        };
    };
    PATCH = @{
        setup = {
            param( [ref]$result )
            setupPatchVariables -result $result
        };
        execute = {
            param( [ref]$result )
            executePatchBySVN -result $result
        };
    };
    PROJECT = @{
        setup = {
            param( [ref]$result )
            setupCMakeVariables -result $result
        };
        execute = {
            param( [ref]$result )
            executeCMake -result $result
        };
    };
    BUILD = @{
        setup = {
            param( [ref]$result )
            setupBuildVariables -result $result
        };
        execute = {
            param( [ref]$result )
            executeBuild -result $result
        };
    };
}




function setupVariables( [ref]$result )
{
    $result.value = $true

    setupCommonVariables

    foreach ( $task in $tasks )
    {
        $phase = $phase_infos[ $task ]
        if ( $phase -ne $null )
        {
            & $phase.setup -result $result

            if ( !$result.value )
            {
                break;
            }
        }
    }
}

function executeTasks( [ref]$result )
{
    $result.value = $true

    executeCommon

    foreach ( $task in $tasks )
    {
        $phase = $phase_infos[ $task ]
        if ( $phase -ne $null )
        {
            & $phase.execute -result ($result)

            if ( !$result.value )
            {
                break;
            }
        }
    }
}



$setup_result = $true
$exec_result = $true

setupVariables -result ([ref]$setup_result)
# setupCMakeVariables -result ([ref]$setup_result)

if ( $setup_result )
{
    Write-Host "setup --- success"

    executeTasks -result ([ref]$exec_result)

    if ( $exec_result )
    {
        Write-Host "exec --- success"
    }
    else
    {
        Write-Host "exec --- failed"
    }
}
else
{
    Write-Host "setup --- failed"
}


# Write-Host $LLVMBuildEnv
# Write-Host $LLVMBuildEnv.SVN
# Write-Host $LLVMBuildEnv.CMAKE
# Write-Host $LLVMBuildEnv.BUILD
# Write-Host $env:Path


# pause

