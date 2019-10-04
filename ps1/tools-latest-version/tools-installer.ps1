# -*- mode: powershell ; coding: utf-8-dos -*-


function DownloadFromURI( [string]$uri, [switch]$expand, [switch]$forceExpand, [switch]$install, [scriptBlock]$afterTask, [switch]$expandPathFromArchiveName, [string]$expandPath )
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
        Start-BitsTransfer -Source $uri -Destination $downloaded_file
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

        if ( $archive_extension -eq ".zip" )
        {
            if ( !( Test-Path -Path $archive_file_name -PathType container ) )
            {
                Write-Host "#expanding : ${downloaded_file}"
                Expand-Archive -Path $downloaded_file -DestinationPath $expandPath -Force
            }
        }
        $cmd = "./7za.exe"
        if ( ( $archive_extension -ne ".zip" ) -and ( Test-Path $cmd ) )
        {
            $check_path = Join-Path $expandPath $archive_file_name

            if ( !( Test-Path -Path $check_path -PathType container ) )
            {
                Write-Host "#expanding : ${downloaded_file}"
                & $cmd x $downloaded_file -aos -o"${expandPath}"
            }

            $archive_extension2 = [System.IO.Path]::GetExtension( $archive_file_name )
            if ( $archive_extension2 -eq ".tar" )
            {
                $extract_name = [System.IO.Path]::GetFileNameWithoutExtension( $archive_file_name )
                if ( !( Test-Path -Path $extract_name -PathType container ) )
                {
                    & $cmd x $archive_file_name -aos -o"${expandPath}"
                }
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
    DownloadFromURI -Uri $URI_7ZIP -Expand

    foreach ( $download in $global:DOWNLOAD_LIST )
    {
        DownloadFromURI @download
    }
}



# preset vars
$DOWNLOAD_LIST = @()
$URI_7ZIP = "http://www.7-zip.org/a/7za920.zip"

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

