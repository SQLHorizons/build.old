Function Add-ClusterVolume
{
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $false)]
        [object]$Disk,
        [parameter(Mandatory = $true, ValueFromPipeline = $false)]
        [string]$Label,
        [parameter(Mandatory = $true, ValueFromPipeline = $false)]
        [string]$AccessPath
    )

    if($Disk)
    {
        Write-Verbose -Message "Checking     existing disk partition style..."
        if ($Disk.PartitionStyle -ne "RAW")
        {
            Set-DiskOnline -Disk $Disk    
            Clear-Disk -Number $Disk.Number -RemoveData –RemoveOEM -Confirm:$false
        }

        Write-Verbose -Message "Initializing disk number '$($Disk.Number)'."
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
                #$ClusterResource = Retry-Command -Command "Start-ClusterResource" -Args @{ InputObject = "$ClusterDisk" } -Verbose
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

            Move-ClusterResource -InputObject $ClusterDisk -Group "DB-OC01"

            if($ClusterDisk.Name -ne "System")
            {
                Set-ClusterResourceDependency -InputObject $ClusterDisk -Dependency "[System]"
            }
            else
            {
                New-Item "S:\Data_X\backup_01", "S:\Data_X\data_01", "S:\Data_X\tLog_01", "S:\Data_X\dtc_01" -type directory | Out-Null
            }
        }
    }
}
