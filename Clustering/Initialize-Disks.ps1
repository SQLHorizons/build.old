Function Initialize-Disks
{
    foreach ($disk in Get-Disk|Where-Object PartitionStyle -eq 'RAW'|Sort-Object Number)
    {
        If ($disk.OperationalStatus -eq 'Offline')
        {
            Set-Disk -Number $disk.Number -IsOffline $False
            Initialize-Disk -Number $disk.Number -PartitionStyle GPT
        }
    }
}

Initialize-Disks
