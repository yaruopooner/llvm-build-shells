# -*- mode: powershell ; coding: utf-8-dos -*-

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
#     }
#     ,@{
#         applyLocation = "llvm/tools/clang/";
#         absolutePath = "ac-clang/clang-server/patch/libclang-x86_64.patch";
#     }
# )


# $llvmVersion = 350
# $platform = 32


$SvnCheckoutInfos = @()
$LLVMSvnOptionFile = "./llvm-svn.options"
$LLVMSvnOptionSrcFile = "${LLVMSvnOptionFile}.sample"


# $cmakePath = "c:/cygwin-x86_64/tmp/cmake-3.0.2-win32-x86/bin"
# $pythonPath = "c:/Python27"
# $gnu32Path = "c:/cygwin-x86_64/tmp/GnuWin32"

$scriptPath = Split-Path $myInvocation.MyCommand.path -Parent
$projectPath = Split-Path $scriptPath -Parent

$LLVMBuildInput = @{}

$LLVMBuildEnv = @{
    LLVMBuildVersion = "trunk";
    CheckoutRepository = "trunk";
    WorkingDir = ".";
    CheckoutRootDir = "";
    BuildDir = "";

    SVN = @{
    };

    CMAKE = @{
        ExecPath = "";
        Msys2Path = "";
        PythonPath = "";
        MSVCVersion = "12 2013";
        Platform = "x64";
        PlatformDir = "msvc2015-64";
        BuildDir = "build";
        GeneratorName = $null;
        CommandLine = $null;

        CONST = @{
            MSVC = @{
                2019 = "16 2019";
                2017 = "15 2017";
                2015 = "14 2015";
                2013 = "12 2013";
                2012 = "11 2012";
                2010 = "10 2010";
            };
            PLATFORM = @{
                32 = @{
                    Name = "Win32";
                };
                64 = @{
                    Name = "x64";
                };
            };
        };
    };

    BUILD = @{
        Msys2Path = "";
        Gnu32Path = "";
        # MSVCVersion = "";
        VcInstallationVersion = ""
        VcRegEntryKeyName = ""
        VcEnvVarName = "";
        VcVarsBatPath = "";
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
                # 2019 = "VS160COMNTOOLS";
                # 2017 = "VS150COMNTOOLS";
                # 2015 = "VS140COMNTOOLS";
                # 2013 = "VS120COMNTOOLS";
                # 2012 = "VS110COMNTOOLS";
                # 2010 = "VS100COMNTOOLS";
                2019 = @{
                    InstallationVersion = "16.*"
                    RegEntryKeyName = "16.0";
                    EnvVarName = "VS160COMNTOOLS";
                    VarsBatPath = "VC\Auxiliary\Build\vcvarsall.bat";
                };
                2017 = @{
                    InstallationVersion = "15.*"
                    RegEntryKeyName = "15.0";
                    EnvVarName = "VS150COMNTOOLS";
                    VarsBatPath = "VC\Auxiliary\Build\vcvarsall.bat";
                };
                2015 = @{
                    InstallationVersion = "14.*"
                    RegEntryKeyName = "14.0";
                    EnvVarName = "VS140COMNTOOLS";
                    VarsBatPath = "VC\vcvarsall.bat";
                };
                2013 = @{
                    InstallationVersion = "12.*"
                    RegEntryKeyName = "12.0";
                    EnvVarName = "VS120COMNTOOLS";
                    VarsBatPath = "VC\vcvarsall.bat";
                };
                2012 = @{
                    InstallationVersion = "11.*"
                    RegEntryKeyName = "11.0";
                    EnvVarName = "VS110COMNTOOLS";
                    VarsBatPath = "VC\vcvarsall.bat";
                };
                2010 = @{
                    InstallationVersion = "10.*"
                    RegEntryKeyName = "10.0";
                    EnvVarName = "VS100COMNTOOLS";
                    VarsBatPath = "VC\vcvarsall.bat";
                };
            };
            VSWHERE = "c:/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe";
            REGISTRY_QUERY = @(
                # 64 = @{
                @{
                    SubKey = "{0}\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VS7";
                    RootKeys = @("HKLM", "HKCU");
                },
                # 32 = @{
                @{
                    SubKey = "{0}\SOFTWARE\Microsoft\VisualStudio\SxS\VS7";
                    RootKeys = @("HKLM", "HKCU");
                }
            );
            # REGISTRY_PRODUCT_DETAILS = @{
            # };
            PLATFORM = @{
                32 = @{
                    Name = "Win32";
                    TargetNameSuffix = "-x86_32";
                    VsCmdPromptArg = "x86";
                };
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


function prependToEnvPath( [string]$path )
{
    if ( $path -ne "" )
    {
        $env:PATH = $path + ";" + $env:PATH
    }
}

function appendToEnvPath( [string]$path )
{
    if ( $path -ne "" )
    {
        $env:PATH += ";" + $path
    }
}

function syncNewDirectory( [string]$targetPath, [ref]$result )
{
    if ( Test-Path $targetPath )
    {
        Write-Host "remove old dir = $targetPath"
        # Remove-Item -path $targetPath -recurse -force
        cmd.exe /c "rmdir /S /Q $targetPath"
    }
    # if ( Test-Path $targetPath )
    # {
    #     $renamed_path = $targetPath
    #     do
    #     {
    #         $renamed_path += "_"
    #     }
    #     while ( Test-Path $renamed_path )

    #     Rename-Item -path $targetPath -newName $renamed_path -force
    #     # Rename-Item -path $targetPath -newName $renamed_path

    #     # check exit code
    #     if ( -not $? )
    #     {
    #         if ( $result )
    #         {
    #             Write-Host "failed rename"
    #             $result.value = $false
    #         }
            
    #         return
    #     }

    #     Write-Host "rename & remove old dir = $targetPath > $renamed_path"
    #     Remove-Item -path $renamed_path -recurse -force
    # }
    while ( Test-Path $targetPath )
    {
        Start-Sleep -m 500
    }
    New-Item -name $targetPath -type directory

    if ( $result )
    {
        $result.value = $true
    }
}

function importScriptEnvVariables( [string]$script, [string]$scriptArg )
{
    $temp_file = [IO.Path]::GetTempFileName()

    cmd /c " `"$script`" $scriptArg && set > `"$temp_file`" "

    Get-Content $temp_file | Foreach-Object {
        if ( $_ -match "^(.*?)=(.*)$" )
        { 
            Set-Content "env:\$($matches[1])" $matches[2]
            Write-Host "$matches[1] = $matches[2]"
        }
    }

    Remove-Item $temp_file
}

function getPlatformDirectoryName()
{
    "msvc{0}-{1}" -f $LLVMBuildInput.msvcVersion, $LLVMBuildInput.platform
    # "msvc${msvcVersion}-${platform}"
}


function Clone-Object( $DeepCopyObject )
{
    $memStream = New-Object IO.MemoryStream
    $formatter = New-Object Runtime.Serialization.Formatters.Binary.BinaryFormatter
    $formatter.Serialize($memStream, $DeepCopyObject)
    $memStream.Position = 0
    $formatter.Deserialize($memStream)
}


# common funcs

function messageHelp()
{
    Write-Host '${llvmVersion} designates llvm version number (e.g 33, 34, 35...)'
    Write-Host 'When ${llvmVersion} is empty that will assign trunk.'
    Write-Host '${workingDirectory} is working directory.'
    Write-Host 'When ${workingDirectory} is empty that will assign /tmp.'
    Write-Host 'Cautions! When a checkout-path exist a same name directory, it deletes and creates. '
}



function setupCommonVariables()
{
    # common
    if ( $LLVMBuildInput.llvmVersion -gt 0 )
    {
        $LLVMBuildEnv.LLVMBuildVersion = $LLVMBuildInput.llvmVersion
        $LLVMBuildEnv.CheckoutRepository = ( "tags/RELEASE_{0}/final" -f $LLVMBuildInput.llvmVersion )
    }
    else
    {
        $LLVMBuildEnv.LLVMBuildVersion = "trunk"
        $LLVMBuildEnv.CheckoutRepository = "trunk"
    }

    $LLVMBuildEnv.CheckoutRootDir = "llvm-" + $LLVMBuildEnv.LLVMBuildVersion
    $LLVMBuildEnv.WorkingDir = "."

    if ( $LLVMBuildInput.workingDirectory -ne "" )
    {
        $LLVMBuildEnv.WorkingDir = $LLVMBuildInput.workingDirectory
    }

    if ( $LLVMBuildEnv.BuildDir -eq "" )
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
    Write-Host "LLVM build target  = " + $LLVMBuildEnv.LLVMBuildVersion
    Write-Host "checkout repository = " + $LLVMBuildEnv.CheckoutRepository
    Write-Host "checkout root directory  = " + $LLVMBuildEnv.CheckoutRootDir
    Write-Host "working directory   = " + $LLVMBuildEnv.WorkingDir
}

function setupCheckoutVariables( [ref]$result )
{
    # setup svn repository URI
    if ( Test-Path -Path $LLVMSvnOptionFile -PathType leaf )
    {
        $src_time = ( Get-ItemProperty -Path $LLVMSvnOptionSrcFile ).LastWriteTime.Ticks
        $dest_time = ( Get-ItemProperty -Path $LLVMSvnOptionFile ).LastWriteTime.Ticks
     
        if ( $src_time -gt $dest_time )
        {
            Copy-Item -Path $LLVMSvnOptionSrcFile -Destination $LLVMSvnOptionFile -Force
        }
    }
    else
    {
        Copy-Item -Path $LLVMSvnOptionSrcFile -Destination $LLVMSvnOptionFile
    }
     
    # overwrite svn vars load
    # load to $global:SvnCheckoutInfos
    if ( Test-Path -Path $LLVMSvnOptionFile -PathType leaf )
    {
        Get-Content $LLVMSvnOptionFile -Raw | Invoke-Expression
    }

    $result.value = $true
}

function executeCheckoutBySVN( [ref]$result )
{
    pushd $LLVMBuildEnv.WorkingDir

    $checkout_root_dir = $LLVMBuildEnv.CheckoutRootDir

    $sync_result = $true
    syncNewDirectory -targetPath $checkout_root_dir -result ([ref]$sync_result)
    if ( !$sync_result )
    {
        $result.value = $false

        return
    }


    # proxy がある場合は ~/.subversion/servers に host と port を指定
    $cmd = "svn"
    $checkout_infos = Clone-Object -DeepCopyObject $global:SvnCheckoutInfos

    # normalized PATH and URI

    # normalize format
    # $checkout_infos = @(
    #     # LLVM
    #     @{
    #         location = $checkout_root_dir;
    #         repository_url = "http://llvm.org/svn/llvm-project/llvm/" + $LLVMBuildEnv.CheckoutRepository;
    #         checkout_dir = "llvm"
    #     }
    #     # Clang
    #     ,@{
    #         location = Join-Path $checkout_root_dir "llvm/tools";
    #         repository_url = "http://llvm.org/svn/llvm-project/cfe/" + $LLVMBuildEnv.CheckoutRepository;
    #         checkout_dir = "clang";
    #     }
    # )

    foreach ( $info in $checkout_infos )
    {
        $info.location = Join-Path $checkout_root_dir $info.location
        $info.repository_url += $LLVMBuildEnv.CheckoutRepository

        # Write-Host $info.location
        # Write-Host $info.repository_url
    }

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

    foreach ( $info in $LLVMBuildInput.patchInfos )
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
    $LLVMBuildEnv.CMAKE.ExecPath = $LLVMBuildInput.cmakePath
    $LLVMBuildEnv.CMAKE.Msys2Path = $LLVMBuildInput.msys2Path
    $LLVMBuildEnv.CMAKE.PythonPath = $LLVMBuildInput.pythonPath

    $cmd = Join-Path $LLVMBuildInput.cmakePath "cmake"
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

    if ( $LLVMBuildInput.msvcVersion -ne 0 )
    {
        $LLVMBuildEnv.CMAKE.MSVCVersion = $const_vars.MSVC[ $LLVMBuildInput.msvcVersion ]
    }

    if ( $LLVMBuildInput.platform -ne 0 )
    {
        $LLVMBuildEnv.CMAKE.GeneratorName = "Visual Studio " + $LLVMBuildEnv.CMAKE.MSVCVersion

        $platform = $const_vars.PLATFORM[ $LLVMBuildInput.platform ].Name
        if ( $platform -ne $null )
        {
            $LLVMBuildEnv.CMAKE.Platform = $platform
        }

        $LLVMBuildEnv.CMAKE.PlatformDir = getPlatformDirectoryName
    }

    $result.value = $true
}


function executeCMake( [ref]$result )
{
    prependToEnvPath -path $LLVMBuildEnv.CMAKE.ExecPath
    if ( $LLVMBuildEnv.CMAKE.PythonPath -ne "" )
    {
        prependToEnvPath -path $LLVMBuildEnv.CMAKE.PythonPath
    }
    if ( $LLVMBuildEnv.CMAKE.Msys2Path -ne "" )
    {
        # don't use prepend.
        # because the cmd of 'windows/system32' will not starts, instead the cmd of 'msys2/mingw64' starts.
        # This is not taken over by the environment variable, 'msbuild' can't be executed.
        appendToEnvPath -path $LLVMBuildEnv.CMAKE.Msys2Path
    }

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

    $sync_result = $true
    syncNewDirectory -targetPath $platform_dir -result ([ref]$sync_result)
    if ( !$sync_result )
    {
        $result.value = $false

        return
    }

    
    cd $platform_dir

    $cmd = "cmake"

    # Write-Host ( "CMAKE.Platform {0}" $LLVMBuildEnv.CMAKE.Platform )

    $cmd_args = @("-G", $LLVMBuildEnv.CMAKE.GeneratorName, "-A", $LLVMBuildEnv.CMAKE.Platform, "..\..\llvm", "-Thost=x64")

    & $cmd $cmd_args

    if ( -not $? )
    {
        Write-Host "failed cmake"
        $result.value = $false

        return
    }

    popd

    $result.value = $true
}



# build funcs

function getVsCmdPromptFromEnvVars( [ref]$result )
{
    $env_var = "env:" + $LLVMBuildEnv.BUILD.VcEnvVarName
    $LLVMBuildEnv.BUILD.VsCmdPrompt = Get-Content $env_var -ErrorAction Ignore

    $result.value = $true
}

function getVsCmdPromptFromRegistry( [ref]$result )
{
    $cmd = "reg"
    $regex = [regex] "^\s+(\S+)\s+REG_SZ\s+(.+)$"

    foreach ( $query_detail in $LLVMBuildEnv.BUILD.CONST.REGISTRY_QUERY )
    {
        foreach ( $root_key in $query_detail.RootKeys )
        {
            $cmd_args = @( "query", ( $query_detail.SubKey -f $root_key ) )
            $query_result = & $cmd $cmd_args

            if ( -not $? )
            {
                continue
            }

            $entries = $query_result.Split("`n", [System.StringSplitOptions]::RemoveEmptyEntries)

            # Write-Host ( "keys = {0}" -f ( $query_detail.SubKey -f $root_key ) )

            foreach ( $entry in $entries )
            {
                # Write-Host "entry = $entry"

                $regex_result = $regex.Matches( $entry )

                if ( $regex_result.Groups.Length -ne 3 )
                {
                    continue
                }

                # Write-Host ( "result = {0} : {1}" -f $regex_result.Groups[1], $regex_result.Groups[2] )

                # if ( $regex_result.Groups[1] -eq $LLVMBuildEnv.BUILD.VcRegEntryKeyName )
                if ( $LLVMBuildEnv.BUILD.VcRegEntryKeyName.Equals( $regex_result.Groups[1].value ) )
                {
                    $LLVMBuildEnv.BUILD.VsCmdPrompt = $regex_result.Groups[2].value

                    $result.value = $true

                    return
                }
            }
        }
    }

    Write-Host "Visual Studio is not detected from Registry!!"

    $result.value = $false
}

function getVsCmdPromptFromVsWhere( [ref]$result )
{
    $cmd = $LLVMBuildEnv.BUILD.CONST.VSWHERE
    $cmd_args = @( "-legacy" )

    $regex_version = [regex] "^installationVersion:\s+(.+)$"
    $regex_path = [regex] "^installationPath:\s+(.+)$"

    if ( !( Test-Path -Path $cmd -PathType leaf ) )
    {
        Write-Host ( "{0} is not found!!" -f $cmd )

        $result.value = $false

        return
    }

    $query_result = & $cmd $cmd_args

    if ( -not $? )
    {
        Write-Host ( "{0} is failed!!" -f $cmd )

        $result.value = $false

        return
    }

    $entries = $query_result.Split("`n", [System.StringSplitOptions]::RemoveEmptyEntries)

    # find version
    $versions = @();
    $installation_paths = @();

    foreach ( $entry in $entries )
    {
        # Write-Host "entry = $entry"

        $regex_result = $regex_version.Matches( $entry )

        if ( $regex_result.Groups.Length -eq 2 )
        {
            # Write-Host ( "version result = {0}" -f $regex_result.Groups[1] )

            $versions += $regex_result.Groups[1].value
        }

        $regex_result = $regex_path.Matches( $entry )

        if ( $regex_result.Groups.Length -eq 2 )
        {
            # Write-Host ( "installationPath result = {0}" -f $regex_result.Groups[1] )

            $installation_paths += $regex_result.Groups[1].value
        }
    }

    if ( $versions.Length -ne $installation_paths.Length )
    {
        $result.value = $false

        return
    }

    $index = 0
    foreach ( $version in $versions )
    {
        # Write-Host "version = $version"

        if ( $version -like $LLVMBuildEnv.BUILD.VcInstallationVersion )
        {
            $LLVMBuildEnv.BUILD.VsCmdPrompt = $installation_paths[ $index ]

            $result.value = $true

            return
        }

        $index += 1
    }

    Write-Host "Visual Studio is not detected by VsWhere!!"

    $result.value = $false
}


function setupBuildVariables( [ref]$result )
{
    $LLVMBuildEnv.BUILD.Gnu32Path = $LLVMBuildInput.gnu32Path

    # local vars
    $const_vars = $LLVMBuildEnv.BUILD.CONST

    if ( $LLVMBuildInput.msvcVersion -ne 0 )
    {
        $LLVMBuildEnv.BUILD.VcInstallationVersion = $const_vars.MSVC[ $LLVMBuildInput.msvcVersion ].InstallationVersion
        $LLVMBuildEnv.BUILD.VcRegEntryKeyName = $const_vars.MSVC[ $LLVMBuildInput.msvcVersion ].RegEntryKeyName
        # $LLVMBuildEnv.BUILD.MSVCVersion = $const_vars.MSVC[ $LLVMBuildInput.msvcVersion ]
        $LLVMBuildEnv.BUILD.VcEnvVarName = $const_vars.MSVC[ $LLVMBuildInput.msvcVersion ].EnvVarName
        $LLVMBuildEnv.BUILD.VcVarsBatPath = $const_vars.MSVC[ $LLVMBuildInput.msvcVersion ].VarsBatPath
    }

    if ( $LLVMBuildInput.target -ne "" )
    {
        $LLVMBuildEnv.BUILD.Target = "/t:" + $LLVMBuildInput.target
    }

    if ( $LLVMBuildInput.platform -ne 0 )
    {
        $LLVMBuildEnv.BUILD.Platform = $const_vars.PLATFORM[ $LLVMBuildInput.platform ].Name
        $LLVMBuildEnv.BUILD.PlatformDir = getPlatformDirectoryName
        $LLVMBuildEnv.BUILD.TargetNameSuffix = $const_vars.PLATFORM[ $LLVMBuildInput.platform ].TargetNameSuffix
        $LLVMBuildEnv.BUILD.VsCmdPromptArg = $const_vars.PLATFORM[ $LLVMBuildInput.platform ].VsCmdPromptArg
    }

    if ( $LLVMBuildInput.configuration -ne "" )
    {
        $LLVMBuildEnv.BUILD.Configuration = $LLVMBuildInput.configuration
    }

    if ( $LLVMBuildInput.additionalProperties -ne "" )
    {
        $LLVMBuildEnv.BUILD.AdditionalProperties = ";" + $LLVMBuildInput.additionalProperties
    }


    # $LLVMBuildEnv.BUILD.VsCmdPrompt = [Environment]::GetEnvironmentVariable($LLVMBuildEnv.BUILD.MSVCVersion, 'Machine')
    # $env_var = "env:" + $LLVMBuildEnv.BUILD.MSVCVersion
    # $LLVMBuildEnv.BUILD.VsCmdPrompt = Get-Content $env_var -ErrorAction Ignore

    $exit_result = $false

    # getVsCmdPromptFromEnvVars -result ([ref]$exit_result)
    # getVsCmdPromptFromRegistry -result ([ref]$exit_result)
    getVsCmdPromptFromVsWhere -result ([ref]$exit_result)
    # check exit code
    # if ( -not $? )
    if ( -not $exit_result )
    {
        getVsCmdPromptFromRegistry -result ([ref]$exit_result)

        if ( -not $exit_result )
        {
            Write-Host ( "Microsoft Visual Studio {0} is not detected!!" -f $LLVMBuildInput.msvcVersion )
            $result.value = $false

            return
        }
    }

    # $LLVMBuildEnv.BUILD.VsCmdPrompt += "../../VC/vcvarsall.bat"
    $LLVMBuildEnv.BUILD.VsCmdPrompt += $LLVMBuildEnv.BUILD.VcVarsBatPath

    # Write-Host $LLVMBuildEnv.BUILD.VsCmdPrompt

    $result.value = $true
}

function executeBuild( [ref]$result )
{
    if ( $LLVMBuildEnv.BUILD.Gnu32Path -ne "" )
    {
        prependToEnvPath -path $LLVMBuildEnv.BUILD.Gnu32Path
    }

    # $script = $LLVMBuildEnv.BUILD.VsCmdPrompt
    # $scriptArg = $LLVMBuildEnv.BUILD.VsCmdPromptArg
    importScriptEnvVariables -script $LLVMBuildEnv.BUILD.VsCmdPrompt -scriptArg $LLVMBuildEnv.BUILD.VsCmdPromptArg

    pushd $LLVMBuildEnv.WorkingDir
    cd $LLVMBuildEnv.CheckoutRootDir
    cd $LLVMBuildEnv.BuildDir
    cd $LLVMBuildEnv.BUILD.PlatformDir

    # return
    $cmd = "msbuild"
    $target = $LLVMBuildEnv.BUILD.Target
    $properties = "/p:Platform=" + $LLVMBuildEnv.BUILD.Platform + ";Configuration=" + $LLVMBuildEnv.BUILD.Configuration + $LLVMBuildEnv.BUILD.AdditionalProperties
    $cmd_args = @("LLVM.sln", $target, $properties, "/maxcpucount", "/fileLogger")

    & $cmd $cmd_args

    if ( -not $? )
    {
        Write-Host "failed msbuild"
        $result.value = $false

        popd

        return
    }

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
    TEST = @{
        setup = {
            param( [ref]$result )
            setupBuildVariables -result $result
        };
        execute = {
            param( [ref]$result )
            $result.value = $true
            # executeBuild -result $result
        };
    };
}




function setupVariables( [ref]$result )
{
    $result.value = $true

    setupCommonVariables

    foreach ( $task in $LLVMBuildInput.tasks )
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

    foreach ( $task in $LLVMBuildInput.tasks )
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


function executeBuilder
{
    Param( 
        [array]$tasks = @(), 
        [int]$llvmVersion,
        [string]$workingDirectory = ".", 
        [int]$msvcVersion = 2013, 
        [string]$target, 
        [int]$platform = 64, 
        [string]$configuration = "Release", 
        [string]$additionalProperties, 
        [string]$cmakePath, 
        [string]$pythonPath, 
        [string]$msys2Path, 
        [string]$gnu32Path, 
        [string]$toolsPrependPath, 
        [string]$toolsAppendPath, 
        [array]$patchInfos
    )

    $LLVMBuildInput = @{
        tasks = $tasks;
        llvmVersion = $llvmVersion;
        workingDirectory = $workingDirectory;
        msvcVersion = $msvcVersion;
        target = $target;
        platform = $platform;
        configuration = $configuration;
        additionalProperties = $additionalProperties;
        cmakePath = $cmakePath;
        pythonPath = $pythonPath;
        msys2Path = $msys2Path;
        gnu32Path = $gnu32Path;
        toolsPrependPath = $toolsPrependPath;
        toolsAppendPath = $toolsAppendPath;
        patchInfos = $patchInfos;
    }

    $setup_result = $true
    $exec_result = $true

    setupVariables -result ([ref]$setup_result)

    # return

    if ( $setup_result )
    {
        Write-Host "setup --- success"

        executeTasks -result ([ref]$exec_result)

        if ( $exec_result )
        {
            Write-Host "execute --- success"
        }
        else
        {
            Write-Host "execute --- failed"
        }
    }
    else
    {
        Write-Host "setup --- failed"
    }

}

# Write-Host $LLVMBuildEnv
# Write-Host $LLVMBuildEnv.SVN
# Write-Host $LLVMBuildEnv.CMAKE
# Write-Host $LLVMBuildEnv.BUILD
# Write-Host $env:Path


# pause

