

function setupEnvironment()
{
    $archive_name = "cmake-3.6.2-win64-x64"
    $download_directory = "./tools-latest-version/"

    if ( !( Test-Path $download_directory ) )
    {
        New-Item -name $download_directory -type directory
    }

    cd $download_directory

    
    $uri = "https://cmake.org/files/v3.6/" + $archive_name + ".zip"
    $downloaded_file = "./cmake.zip"

    
    Invoke-WebRequest -Uri $uri -OutFile $downloaded_file

    # expand zip
    $archive_dest_path = "./"
    $archived_path = $archive_dest_path + $archive_name
    if ( ( Test-Path -path $archived_path -pathType container ) )
    {
        Remove-Item -path $archived_path -recurse -force
    }
    Expand-Archive -Path $downloaded_file -DestinationPath $archive_dest_path
}


setupEnvironment

[Console]::ReadKey()

