Function New-DirectorySet
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object]$directories
    )

    foreach ($directory in $directories)
    {
        $null = New-Item -Path $directory -ItemType directory -Force
        Write-Verbose "Directory $($directory) exists $(Test-Path -Path $directory)."
    }
}
