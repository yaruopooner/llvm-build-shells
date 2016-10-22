# -*- mode: powershell ; coding: utf-8-dos -*-


function DownloadFromURI( [string]$uri, [switch]$expand, [switch]$forceExpand, [switch]$install )
{
    if ( $uri.Length -eq 0 )
    {
        Write-Host "invalid URI=$uri"
    
        return
    }

    # directory check
    $download_directory = "./tools-latest-version/"

    if ( !( Test-Path $download_directory ) )
    {
        New-Item -Name $download_directory -Type directory
    }

    pushd $download_directory

    # download
    $downloaded_file = [System.IO.Path]::GetFileName( $uri )

    if ( !( Test-Path $downloaded_file ) )
    {
        Write-Host "#downloading : ${uri}"
        Invoke-WebRequest -Uri $uri -OutFile $downloaded_file
    }
    else
    {
        Write-Host "#already exist : ${uri}"
    }
    

    # archive expand
    if ( $expand )
    {
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
    
    popd
}



function setupEnvironment()
{
    DownloadFromURI -Uri $URI_7ZIP -Expand

    foreach ( $download in $DOWNLOAD_LIST )
    {
        DownloadFromURI -Uri $download.URI $download.OPTIONS
    }
}


# preset vars
$DOWNLOAD_LIST = @()
$URI_7ZIP = "http://www.7-zip.org/a/7za920.zip"

# overwrite vars load
if ( Test-Path -Path "./tools-installer.options" -PathType leaf )
{
    Get-Content "./tools-installer.options" -Raw | Invoke-Expression
}


setupEnvironment


[Console]::ReadKey()

