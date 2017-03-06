Function Set-DisksOnline
{
    foreach ($disk in Get-Disk|Where-Object PartitionStyle -eq 'RAW'|Sort-Object Number)
    {
        If ($disk.OperationalStatus -eq 'Offline')
        {
            Set-Disk -Number $disk.Number -IsOffline $False
        }
    }
}

Set-DisksOnline
