# -*- mode: shell-script ; coding: utf-8-dos -*-


function DownloadFromURI( [string]$uri, [switch]$expand, [switch]$forceExpand, [switch]$install )
{
    if ( $uri.Length -eq 0 )
    {
        Write-Host "invalid URI"
    
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
        Write-Host "#downloading : " + $uri
        Invoke-WebRequest -Uri $uri -OutFile $downloaded_file
    }
    else
    {
        Write-Host "#already exist : " + $uri
    }
    

    # archive expand
    if ( $expand )
    {
        $extension = [System.IO.Path]::GetExtension( $downloaded_file )
        if ( ( $extension -eq ".zip" ) -or $forceExpand )
        {
            $expanded_path = [System.IO.Path]::GetFileNameWithoutExtension( $downloaded_file )

            if ( !( Test-Path -Path $expanded_path -PathType container ) )
            {
                Write-Host "#expanding : " + $downloaded_file
                Expand-Archive -Path $downloaded_file -DestinationPath "./" -Force
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


function SetupEnvironment()
{
    DownloadFromURI -Uri $URI_CMAKE -Expand
    DownloadFromURI -Uri $URI_PYTHON -Install
    DownloadFromURI -Uri $URI_GNU_TOOLS -Install
}


# preset vars
$URI_CMAKE = ""
$URI_PYTHON = ""
$URI_GNU_TOOLS = ""

# overwrite vars load
if ( Test-Path -Path "./tools-installer.options" -PathType leaf )
{
    Get-Content "./tools-installer.options" -Raw | Invoke-Expression
}


setupEnvironment

[Console]::ReadKey()

