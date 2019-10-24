# -*- mode: powershell ; coding: utf-8-dos -*-

# $tasks = @("CHECKOUT", "PATCH", "PROJECT", "BUILD")
# $tasks = @("CHECKOUT", "PROJECT", "BUILD")
# $tasks = @("CHECKOUT", "PROJECT")
# $tasks = @("CHECKOUT")
# $tasks = @("PROJECT")

# $platform = 32


$GitCheckoutInfos = @()
$LLVMGitOptionFile = "./llvm-git.options"
$LLVMGitOptionSrcFile = "${LLVMGitOptionFile}.sample"
$CMakeInfos = @()
$LLVMCMakeOptionFile = "./llvm-cmake.options"
$LLVMCMakeOptionSrcFile = "${LLVMCMakeOptionFile}.sample"


# $cmakePath = "c:/cygwin-x86_64/tmp/cmake-3.0.2-win32-x86/bin"
# $pythonPath = "c:/Python27"
# $gnu32Path = "c:/cygwin-x86_64/tmp/GnuWin32"

$scriptPath = Split-Path $myInvocation.MyCommand.path -Parent
$projectPath = Split-Path $scriptPath -Parent

$LLVMBuildInput = @{}

$LLVMBuildEnv = @{
    LLVMBuildVersion = "llvmorg-9.0.0";
    WorkingDir = ".";
    BuildDir = "";

    GIT = @{
        ExecPath = "";
    };

    CMAKE = @{
        ExecPath = "";
        Msys2Path = "";
        PythonPath = "";
        MSVCProductName = "12 2013";
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
        # MSVCProductName = "";
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

    Write-Host ( "invoke environment {0} {1}" -f $script, $scriptArg )

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
    "msvc{0}-{1}" -f $LLVMBuildInput.msvcProductName, $LLVMBuildInput.platform
    # "msvc${msvcProductName}-${platform}"
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


function setupVariablesOnOptionFile( [string]$inOptionFilePath, [string]$inOriginalOptionFilePath )
{
    # setup option file
    if ( Test-Path -Path $inOptionFilePath -PathType leaf )
    {
        $src_time = ( Get-ItemProperty -Path $inOriginalOptionFilePath ).LastWriteTime.Ticks
        $dest_time = ( Get-ItemProperty -Path $inOptionFilePath ).LastWriteTime.Ticks

        if ( $src_time -gt $dest_time )
        {
            Copy-Item -Path $inOriginalOptionFilePath -Destination $inOptionFilePath -Force
        }
    }
    else
    {
        Copy-Item -Path $inOriginalOptionFilePath -Destination $inOptionFilePath
    }

    # overwrite option-files variables
    # load to $global: variables
    if ( Test-Path -Path $inOptionFilePath -PathType leaf )
    {
        Get-Content $inOptionFilePath -Raw | Invoke-Expression
    }
}


function setupCommonVariables()
{
    setupVariablesOnOptionFile -inOptionFilePath $LLVMGitOptionFile -inOriginalOptionFilePath $LLVMGitOptionSrcFile
    setupVariablesOnOptionFile -inOptionFilePath $LLVMCMakeOptionFile -inOriginalOptionFilePath $LLVMCMakeOptionSrcFile

    # common
    if ( $LLVMBuildInput.llvmCheckoutTag.Length -ne 0 )
    {
        $LLVMBuildEnv.LLVMBuildVersion = $LLVMBuildInput.llvmCheckoutTag
    }
    else
    {
        $LLVMBuildEnv.LLVMBuildVersion = $global:GitCheckoutInfos.DefaultCheckoutTag
    }

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


# GIT funcs


function messageCheckoutEnvironment()
{
    Write-Host "LLVM build target  = " + $LLVMBuildEnv.LLVMBuildVersion
    Write-Host "working directory   = " + $LLVMBuildEnv.WorkingDir
}



# GIT funcs

function setupCheckoutVariables( [ref]$result )
{
    $LLVMBuildEnv.GIT.ExecPath = $LLVMBuildInput.gitPath
}

function executeCheckout( [ref]$result )
{
    if ( $LLVMBuildEnv.GIT.ExecPath -ne "" )
    {
        prependToEnvPath -path $LLVMBuildEnv.GIT.ExecPath
    }

    pushd $LLVMBuildEnv.WorkingDir

    # proxy がある場合は ~/.gitconfig に host と port を指定 or AdditionalOptions に記述
    $checkout_infos = Clone-Object -DeepCopyObject $global:GitCheckoutInfos

    # normalized PATH and URI

    # normalize format
    # $global:GitCheckoutInfos = @(
    #     # LLVM
    #     RepositoryURL = "https://github.com/llvm/llvm-project.git";
    #     DefaultCheckoutTag = "llvmorg-9.0.0";
    #     Fetch = $false;
    # )


    $cmd = "git"

    # check exist repository
    if ( Test-Path $checkout_infos.RepositoryName )
    {
        if ( $checkout_infos.Fetch )
        {
            pushd $checkout_infos.RepositoryName

            # fetch
            $cmd_args = @("fetch")
            Write-Host $cmd_args
            & $cmd $cmd_args
            # fetch all tags
            $cmd_args = @("--tags")
            Write-Host $cmd_args
            & $cmd $cmd_args

            popd
        }
    }
    else
    {
        # clone
        $base_options = @("clone", "--config", "core.autocrlf=false", $checkout_infos.RepositoryURL)

        # add external options
        $cmd_args = $base_options + $checkout_infos.AdditionalOptions

        Write-Host $cmd_args
        & $cmd $cmd_args
    }

    # checkout branch
    if ( Test-Path $checkout_infos.RepositoryName )
    {
        pushd $checkout_infos.RepositoryName

        $tag = $LLVMBuildEnv.LLVMBuildVersion

        # branch clean
        $cmd_args = @("clean", "-df")
        Write-Host $cmd_args
        & $cmd $cmd_args

        # branch reset
        # $cmd_args = @("reset", "--hard")
        # Write-Host $cmd_args
        # & $cmd $cmd_args

        # branch checkout
        $start_point = "refs/tags/" + $tag
        $branch = $tag
        $cmd_args = @("checkout", "--force", "-B", $branch, $start_point)
        Write-Host $cmd_args
        & $cmd $cmd_args

        popd
    }

    $result.value = $true
}


# patch funcs

function setupPatchVariables( [ref]$result )
{
    $LLVMBuildEnv.GIT.ExecPath = $LLVMBuildInput.gitPath

    $result.value = $true
}

function executePatch( [ref]$result )
{
    if ( $LLVMBuildEnv.GIT.ExecPath -ne "" )
    {
        prependToEnvPath -path $LLVMBuildEnv.GIT.ExecPath
    }

    pushd $global:GitCheckoutInfos.RepositoryName

    $cmd = "git"

    foreach ( $patch in $global:GitCheckoutInfos.Patches )
    {
        $resolved_path = ( Resolve-Path ( Join-Path $scriptPath $patch ) )

        $cmd_args = @("apply", $resolved_path)
        # $cmd_args = @("apply", "--check", $resolved_path)
        Write-Host $cmd_args
        & $cmd $cmd_args
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

    if ( $LLVMBuildInput.msvcProductName -ne 0 )
    {
        $LLVMBuildEnv.CMAKE.MSVCProductName = $const_vars.MSVC[ $LLVMBuildInput.msvcProductName ]
    }

    if ( $LLVMBuildInput.platform -ne 0 )
    {
        $LLVMBuildEnv.CMAKE.GeneratorName = "Visual Studio " + $LLVMBuildEnv.CMAKE.MSVCProductName

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

    # build directory
    if ( !( Test-Path $LLVMBuildEnv.BuildDir ) )
    {
        New-Item -name $LLVMBuildEnv.BuildDir -type directory
    }
    cd $LLVMBuildEnv.BuildDir

    # llvm build version directory
    if ( !( Test-Path $LLVMBuildEnv.LLVMBuildVersion ) )
    {
        New-Item -name $LLVMBuildEnv.LLVMBuildVersion -type directory
    }
    cd $LLVMBuildEnv.LLVMBuildVersion

    # platform directory
    $sync_result = $true
    syncNewDirectory -targetPath $LLVMBuildEnv.CMAKE.PlatformDir -result ([ref]$sync_result)
    if ( !$sync_result )
    {
        $result.value = $false

        return
    }
    
    cd $LLVMBuildEnv.CMAKE.PlatformDir

    $cmd = "cmake"

    # Write-Host ( "CMAKE.Platform {0}" $LLVMBuildEnv.CMAKE.Platform )

    $base_options = @("-G", $LLVMBuildEnv.CMAKE.GeneratorName, "-A", $LLVMBuildEnv.CMAKE.Platform, "..\..\..\llvm-project\llvm")

    # add external options
    $cmd_args = $base_options + $global:CMakeInfos.AdditionalOptions


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

    $regex_segment_header = [regex] "^instanceId:"
    $regex_version = [regex] "(?m:installationVersion:\s+(.+)$)"
    $regex_path = [regex] "(?m:installationPath:\s+(.+)$)"
    # $regex_version = [regex] "(?m:^installationVersion:)"
    # $regex_path = [regex] "(?m:^installationPath:)"

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

    # The result value is array.
    # If there are multiple lines of command result data, powershell splited the data by "`n" code and returns it.
    # Rejoin them.
    $query_result = $query_result -Join "`n"

    # $entries = $query_result.Split([regex]"(?m:^)`n", [System.StringSplitOptions]::RemoveEmptyEntries)
    # $entries = $query_result.Split([string[]]"^`n", [System.StringSplitOptions]::RemoveEmptyEntries, "RegexMatch")
    # $entries = $query_result.Split($pattern)
    # $entries = $query_result.Split([regex]"^`r`n", [System.StringSplitOptions]::RemoveEmptyEntries)
    $entries = $query_result -Split "^`n", 0, "RegexMatch, Multiline"

    # find version
    foreach ( $entry in $entries )
    {
        # Write-Host "entry = $entry"

        $regex_result = $regex_segment_header.Matches( $entry )

        if ( !$regex_result.Success )
        {
            continue
        }

        $version = $null
        $installation_path = $null

        $regex_result = $regex_version.Matches( $entry )
        # Write-Host ("version result {0}" -f $regex_result.Count)

        if ( $regex_result.Success -and ($regex_result.Groups.Length -eq 2) )
        {
            # Write-Host ( "version result = {0}" -f $regex_result.Groups[1] )

            $version = $regex_result.Groups[1].value
        }

        $regex_result = $regex_path.Matches( $entry )

        # Write-Host ("path result {0}" -f $regex_result.Count)

        if ( $regex_result.Success -and ($regex_result.Groups.Length -eq 2) )
        {
            # Write-Host ( "installationPath result = {0}" -f $regex_result.Groups[1] )

            $installation_path = $regex_result.Groups[1].value
        }

        if ( ($version -ne $null) -and ($installation_path -ne $null) )
        {
            if ( $version -like $LLVMBuildEnv.BUILD.VcInstallationVersion )
            {
                $LLVMBuildEnv.BUILD.VsCmdPrompt = $installation_path

                $result.value = $true

                return
            }
        }
    }


    Write-Host "Visual Studio is not detected by VsWhere!!"

    $result.value = $false
}


function setupBuildVariables( [ref]$result )
{
    $LLVMBuildEnv.BUILD.Gnu32Path = $LLVMBuildInput.gnu32Path

    # local vars
    $const_vars = $LLVMBuildEnv.BUILD.CONST

    if ( $LLVMBuildInput.msvcProductName -ne 0 )
    {
        $LLVMBuildEnv.BUILD.VcInstallationVersion = $const_vars.MSVC[ $LLVMBuildInput.msvcProductName ].InstallationVersion
        $LLVMBuildEnv.BUILD.VcRegEntryKeyName = $const_vars.MSVC[ $LLVMBuildInput.msvcProductName ].RegEntryKeyName
        # $LLVMBuildEnv.BUILD.MSVCProductName = $const_vars.MSVC[ $LLVMBuildInput.msvcProductName ]
        $LLVMBuildEnv.BUILD.VcEnvVarName = $const_vars.MSVC[ $LLVMBuildInput.msvcProductName ].EnvVarName
        $LLVMBuildEnv.BUILD.VcVarsBatPath = $const_vars.MSVC[ $LLVMBuildInput.msvcProductName ].VarsBatPath
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


    # $LLVMBuildEnv.BUILD.VsCmdPrompt = [Environment]::GetEnvironmentVariable($LLVMBuildEnv.BUILD.MSVCProductName, 'Machine')
    # $env_var = "env:" + $LLVMBuildEnv.BUILD.MSVCProductName
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
            Write-Host ( "Microsoft Visual Studio {0} is not detected!!" -f $LLVMBuildInput.msvcProductName )
            $result.value = $false

            return
        }
    }

    # $LLVMBuildEnv.BUILD.VsCmdPrompt += "../../VC/vcvarsall.bat"
    $LLVMBuildEnv.BUILD.VsCmdPrompt = Join-Path $LLVMBuildEnv.BUILD.VsCmdPrompt $LLVMBuildEnv.BUILD.VcVarsBatPath

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
    cd $LLVMBuildEnv.BuildDir
    cd $LLVMBuildEnv.LLVMBuildVersion
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
            executeCheckout -result $result
        };
    };
    PATCH = @{
        setup = {
            param( [ref]$result )
            setupPatchVariables -result $result
        };
        execute = {
            param( [ref]$result )
            executePatch -result $result
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
        [string]$llvmCheckoutTag,
        [string]$workingDirectory = ".", 
        [int]$msvcProductName = 2013, 
        [string]$target, 
        [int]$platform = 64, 
        [string]$configuration = "Release", 
        [string]$additionalProperties, 
        [string]$gitPath, 
        [string]$cmakePath, 
        [string]$pythonPath, 
        [string]$msys2Path, 
        [string]$gnu32Path, 
        [string]$toolsPrependPath, 
        [string]$toolsAppendPath
    )

    $LLVMBuildInput = @{
        tasks = $tasks;
        llvmCheckoutTag = $llvmCheckoutTag;
        workingDirectory = $workingDirectory;
        msvcProductName = $msvcProductName;
        target = $target;
        platform = $platform;
        configuration = $configuration;
        additionalProperties = $additionalProperties;
        gitPath = $gitPath;
        cmakePath = $cmakePath;
        pythonPath = $pythonPath;
        msys2Path = $msys2Path;
        gnu32Path = $gnu32Path;
        toolsPrependPath = $toolsPrependPath;
        toolsAppendPath = $toolsAppendPath;
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
# Write-Host $LLVMBuildEnv.GIT
# Write-Host $LLVMBuildEnv.CMAKE
# Write-Host $LLVMBuildEnv.BUILD
# Write-Host $env:Path


# pause

