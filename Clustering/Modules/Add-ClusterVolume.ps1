Function Add-ClusterVolume
{
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $false)]
        [object]$Disk,
        [parameter(Mandatory = $true, ValueFromPipeline = $false)]
        [string]$Label,
        [parameter(Mandatory = $true, ValueFromPipeline = $false)]
        [string]$AccessPath,
        [parameter(Mandatory = $true, ValueFromPipeline = $false)]
        [string]$Group
    )

    if($Disk)
    {
        Write-Verbose -Message "Checking     existing disk partition style..."
        if ($Disk.PartitionStyle -ne "RAW")
        {           
            Set-DiskOnline -Disk $Disk
            Write-Verbose -Message "Clearing Disk, RemoveData and RemoveOEM."    
            Clear-Disk -Number $Disk.Number -RemoveData –RemoveOEM -Confirm:$false
        }

        Write-Verbose -Message "Initializing disk number '$($Disk.Number)'."
        Start-Sleep -Seconds 15
        Set-DiskOnline -Disk $Disk
        $Disk | Initialize-Disk -PartitionStyle "GPT" -PassThru|Out-Null

        $ClusterAvailableDisk = @{
        Disk = Get-Disk -Number $Disk.Number
        #ErrorAction = "SilentlyContinue"
        WarningAction = "SilentlyContinue"
        }

        $AvailableDisk = Get-ClusterAvailableDisk @ClusterAvailableDisk

        if($AvailableDisk)
        {
            $ClusterDisk   = Add-ClusterDisk -InputObject $AvailableDisk
            $ClusterDisk.Name = $Label

            $Partition = New-Partition  -DiskNumber $Disk.Number -UseMaximumSize
            Start-Sleep -Seconds 15

            if($ClusterDisk.State -eq "Offline")
            {
                $ClusterResource = Start-ClusterResource -InputObject $ClusterDisk
            }

            Suspend-ClusterResource -Name $ClusterDisk.Name -Force|Out-Null

            Write-Verbose -Message "Formatting   the '$($config.name)' volume..."
            $VolParams = @{
                FileSystem         = "NTFS";
                Confirm            = $false;
                NewFileSystemLabel = $Label;
                AllocationUnitSize = 64KB
                }

            $Volume = $Partition | Format-Volume @VolParams
            Resume-ClusterResource -Name $ClusterDisk.Name|Out-Null

            $AddPartitionAccessPath = @{
                InputObject = $Partition
                AccessPath = $AccessPath
                ErrorAction = "Stop"
                PassThru = $true
                }

            $PartitionAccessPath = Add-PartitionAccessPath @AddPartitionAccessPath

            Move-ClusterResource -InputObject $ClusterDisk -Group $Group

            if($ClusterDisk.Name -ne "System")
            {
                Set-ClusterResourceDependency -InputObject $ClusterDisk -Dependency "[System]"
            }
            else
            {
                New-Item "$AccessPath\Data_X\backup_01", "$AccessPath\Data_X\data_01", "$AccessPath\Data_X\tLog_01", "$AccessPath\Data_X\dtc_01" -type directory | Out-Null
            }
        }
    }
}
