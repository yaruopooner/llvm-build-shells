# -*- mode: powershell ; coding: utf-8-dos -*-


function DownloadFromURI( [string]$uri, [switch]$expand, [switch]$forceExpand, [switch]$install, [scriptBlock]$afterTask )
{
    if ( $uri.Length -eq 0 )
    {
        Write-Host "invalid URI=$uri"
    
        return
    }

    # download
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
    if ( $expand )
    {
        Write-Host "#expand : ${downloaded_file}"

        $extension = [System.IO.Path]::GetExtension( $downloaded_file )
        $expanded_path = [System.IO.Path]::GetFileNameWithoutExtension( $downloaded_file )

        if ( $extension -eq ".zip" )
        {
            if ( !( Test-Path -Path $expanded_path -PathType container ) )
            {
                Write-Host "#expanding : ${downloaded_file}"
                Expand-Archive -Path $downloaded_file -DestinationPath "./" -Force
            }
        }
        $cmd = "./7za.exe"
        if ( ( ( $extension -eq ".xz" ) -or ( $extension -eq ".gz" ) ) -and ( Test-Path $cmd ) )
        {
            if ( !( Test-Path -Path $expanded_path -PathType any ) )
            {
                Write-Host "#expanding : ${downloaded_file}"
                & $cmd x $downloaded_file -aos
            }

            $extension2 = [System.IO.Path]::GetExtension( $expanded_path )
            if ( $extension2 -eq ".tar" )
            {
                $extract_name = [System.IO.Path]::GetFileNameWithoutExtension( $expanded_path )
                if ( !( Test-Path -Path $extract_name -PathType any ) )
                {
                    & $cmd x $expanded_path -aos
                }
            }
        }
    }

    # installer execute 
    if ( $install )
    {
        Start-Process -FilePath $downloaded_file
    }

    # afterTask execute 
    if ( $afterTask )
    {
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

