Function Copy-Folder
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Source,
        [parameter(Mandatory = $true)]
        [string]$Destination
    )
    
    $process = "Robocopy.exe"
    $Arguments = @(
        "$Source"
        "$Destination"
        "/MIR"
        "/NP"
        "/NS"
        "/NC"
        "/NFL"
        "/NDL"
        "/NJH"
        "/NJS"
    )
    Start-Process $process -ArgumentList $Arguments -Wait -WindowStyle Hidden
}
