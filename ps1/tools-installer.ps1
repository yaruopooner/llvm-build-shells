



function DownloadFromURI( $uri, [switch]$expand, [switch]$forceExpand, [switch]$install )
{
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
        echo "#downloading : " + $uri
        Invoke-WebRequest -Uri $uri -OutFile $downloaded_file
    }
    else
    {
        echo "#already exist : " + $uri
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
                echo "#expanding : " + $downloaded_file
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
    
    $uri_cmake = "https://cmake.org/files/v3.6/cmake-3.6.2-win64-x64.zip"
    $uri_python = "https://www.python.org/ftp/python/2.7.12/python-2.7.12.amd64.msi"
    $uri_gnu_tools = "http://jaist.dl.sourceforge.net/project/getgnuwin32/getgnuwin32/0.6.30/GetGnuWin32-0.6.3.exe"

    DownloadFromURI -Uri $uri_cmake -Expand
    DownloadFromURI -Uri $uri_python -Install
    DownloadFromURI -Uri $uri_gnu_tools -Install
}


setupEnvironment

[Console]::ReadKey()

