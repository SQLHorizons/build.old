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
    }
        
    if ($Disk.IsReadOnly -eq $true)
    {
        Write-Verbose "Setting      disk number '$($Disk.Number)' to not ReadOnly"
        $Disk | Set-Disk -IsReadOnly $false
    }
}
