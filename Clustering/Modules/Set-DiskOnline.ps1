Function Set-DiskOnline
{
    param
    (
        [object]$Disk
    )

    if ($Disk.IsOffline -eq $true)
    {
        Write-Verbose "Setting      disk number '$($Disk.Number)' Online"
        $Disk | Set-Disk -IsOffline $false

        if ((Get-Disk -Number $Disk.Number).IsOffline -eq $true)
        {
            Throw "Failed to set disk number '$($Disk.Number)' Online"
        }
    }
        
    if ($Disk.IsReadOnly -eq $true)
    {
        Write-Verbose "Setting      disk number '$($Disk.Number)' to not ReadOnly"
        $Disk | Set-Disk -IsReadOnly $false

        if ((Get-Disk -Number $Disk.Number).IsReadOnly -eq $true)
        {
            Throw "Failed to set disk number '$($Disk.Number)' to not ReadOnly"
        }
    }
}
