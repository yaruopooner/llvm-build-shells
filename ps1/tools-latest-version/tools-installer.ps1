# -*- mode: powershell ; coding: utf-8-dos -*-


function DownloadFromURI( [string]$uri, [switch]$expand, [switch]$forceExpand, [switch]$install, [scriptBlock]$afterTask, [switch]$expandPathFromArchiveName, [string]$expandPath, [switch]$expandBy7zip )
{
    Write-Host "========== DownloadFromURI =========="
    Write-Host "#URI : ${uri}"

    if ( $uri.Length -eq 0 )
    {
        Write-Host "invalid URI=$uri"
    
        return
    }

    if ( $expandPath.Length -eq 0 )
    {
        # current path
        $expandPath = "./"
    }

    # download
    Write-Host "---------- Download ----------"
    $downloaded_file = [System.IO.Path]::GetFileName( $uri )

    if ( !( Test-Path $downloaded_file ) )
    {
        Write-Host "#downloading : ${uri}"
        # Invoke-WebRequest -Uri $uri -OutFile $downloaded_file
        # Start-BitsTransfer -Source $uri -Destination $downloaded_file
        $wc = New-Object System.Net.WebClient
        $wc.DownloadFile( $uri, $downloaded_file )
    }
    else
    {
        Write-Host "#already exist : ${uri}"
    }
    

    # archive expand
    Write-Host "---------- Expand ----------"
    if ( $expand )
    {
        Write-Host "#expand : ${downloaded_file}"

        $archive_extension = [System.IO.Path]::GetExtension( $downloaded_file )
        $archive_file_name = [System.IO.Path]::GetFileNameWithoutExtension( $downloaded_file )

        if ( $expandPathFromArchiveName )
        {
            $expandPath = $archive_file_name
        }

        if ( $expandBy7zip )
        {
            # 7zip
            if ( $archive_extension -eq ".zip" )
            {
                if ( !( Test-Path -Path $archive_file_name -PathType container ) )
                {
                    Write-Host "#expanding : ${downloaded_file}"
                    Expand-Archive -Path $downloaded_file -DestinationPath $expandPath -Force
                    Write-Host "#expand ===> completed"
                }
            }

            $cmd = "./7za.exe"
            if ( ( $archive_extension -ne ".zip" ) -and ( Test-Path $cmd ) )
            {
                $archive_extension2 = [System.IO.Path]::GetExtension( $archive_file_name )
                $is_tar = $archive_extension2 -eq ".tar"

                $tmp_path = $expandPath

                if ( $is_tar )
                {
                    $tmp_path = "./"
                }

                $check_path = Join-Path $tmp_path $archive_file_name

                if ( !( Test-Path -Path $check_path -PathType container ) )
                {
                    Write-Host "#expanding : ${downloaded_file}"
                    & $cmd x $downloaded_file -aos -o"${tmp_path}"
                    Write-Host "#expand ===> completed"
                }

                if ( $is_tar )
                {
                    $extract_name = [System.IO.Path]::GetFileNameWithoutExtension( $archive_file_name )
                    if ( !( Test-Path -Path $extract_name -PathType container ) )
                    {
                        & $cmd x $archive_file_name -aos -o"${expandPath}"
                        Write-Host "#expand ===> completed"
                    }
                }
            }
        }
        else
        {
            # tar
            if ( Test-Path $TAR_CMD )
            {
                if ( !( Test-Path -Path $expandPath -PathType container ) )
                {
                    & mkdir $expandPath
                }

                # $cmd_args = @("-v", "-x", "-f", "${downloaded_file}", "-C", "${expandPath}")

                # Write-Host "cmd_args ${cmd_args}"

                # & $TAR_CMD $cmd_args
                & $TAR_CMD -v -x -f "${downloaded_file}" -C "${expandPath}"

                Write-Host "#expand ===> completed"
            }
            else
            {
                Write-Host "#error : ${TAR_CMD} is not found!"
            }
        }

    }

    # installer execute 
    if ( $install )
    {
        Write-Host "---------- Install ----------"
        Start-Process -FilePath $downloaded_file
    }

    # afterTask execute 
    if ( $afterTask )
    {
        Write-Host "---------- AfterTask ----------"
        & $afterTask
    }
}



function setupEnvironment()
{
    DownloadFromURI @global:URI_7ZIP
    DownloadFromURI @global:URI_MSYS2

    foreach ( $download in $global:DOWNLOAD_LIST )
    {
        DownloadFromURI @download
    }
}



# preset vars
$URI_7ZIP = @{}
$URI_MSYS2 = @{}
$DOWNLOAD_LIST = @()

$MSYS2_USR_BIN = "./msys64/usr/bin/"
$TAR_CMD = Join-Path $MSYS2_USR_BIN "bsdtar.exe"


$installer_option_file = "./tools-installer.options"
$installer_option_src_file = "${installer_option_file}.sample"

if ( Test-Path -Path $installer_option_file -PathType leaf )
{
    $src_time = ( Get-ItemProperty -Path $installer_option_src_file ).LastWriteTime.Ticks
    $dest_time = ( Get-ItemProperty -Path $installer_option_file ).LastWriteTime.Ticks

    if ( $src_time -gt $dest_time )
    {
        Copy-Item -Path $installer_option_src_file -Destination $installer_option_file -Force
    }
}
else
{
    Copy-Item -Path $installer_option_src_file -Destination $installer_option_file
}

# overwrite vars load
if ( Test-Path -Path $installer_option_file -PathType leaf )
{
    Get-Content $installer_option_file -Raw | Invoke-Expression
}


setupEnvironment


[Console]::ReadKey()

