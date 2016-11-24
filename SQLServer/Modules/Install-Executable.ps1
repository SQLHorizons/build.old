Function Install-Executable
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$ExecutableName,
        [parameter(Mandatory = $true)]
        [string]$ExecutablePath
    )
    
    $RegistryPath = "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    
    if (-not ((Get-ItemProperty $RegistryPath).Where{ $_.DisplayName -like $ExecutableName }))
    {
        if ((Get-Process).Where{ $_.ProcessName -eq "msiexec" })
        { Wait-Process -Id (Get-Process).Where{ $_.ProcessName -eq "msiexec" }.Id }
        Write-Verbose "Installing $($ExecutableName)..."
        
        $process = $ExecutablePath
        $log = $process.split("\")[-1].Replace(".exe", "")
        $setupArguments = @(
            "/install"
            "/passive"
            "/norestart"
            "/log $($env:TEMP)\$($env:COMPUTERNAME)_$($log).log"
        )
        Start-Process $process -ArgumentList $setupArguments -Wait -WindowStyle Hidden
    }
    
}
