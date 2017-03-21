Function Initialize-CluesterDisk
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Label,
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$AccessPath,
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [uint16]$DiskNumber,
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object]$ClusterGroup
    )

    Prepare-Disk -Number $DiskNumber|Out-Null

    $ClusterAvailableDisk = @{
        Disk = $(Get-Disk -Number $DiskNumber)
        ErrorAction = "SilentlyContinue"
        WarningAction = "SilentlyContinue"
        }

    $AvailableDisk = Get-ClusterAvailableDisk @ClusterAvailableDisk
    if($AvailableDisk)
    {
        $ClusterDisk   = Add-ClusterDisk -InputObject $AvailableDisk
        $ClusterDisk.Name = $Label
    }

    $PartParams = @{DiskNumber = $DiskNumber; UseMaximumSize = $true }
    $Partition = New-Partition @PartParams

    #while($Partition.OperationalStatus -ne "Online"){Start-Sleep -Seconds 2}
    Start-Sleep -Seconds 30

    if($ClusterDisk.State -eq "Offline")
    {
        $ClusterResource = Start-ClusterResource $ClusterDisk -ErrorAction Stop
        #while($ClusterResource -ne "Online"){Start-Sleep -Seconds 2}
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

    $PartitionAccessPath = $Partition | Add-PartitionAccessPath -AccessPath $AccessPath -ErrorAction Stop -PassThru

}

#Clear-Disk -Number 4 -RemoveData –RemoveOEM -Confirm:$false -ErrorAction SilentlyContinue

    $CluesterDisk = @{
        Label = "Quorum"
        AccessPath = "Q:"
        DiskNumber = 4
        ClusterGroup = $ClusterGroup
        }

    Initialize-CluesterDisk @CluesterDisk
