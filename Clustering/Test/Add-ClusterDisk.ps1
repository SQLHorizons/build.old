Add-ClusterGroup -Name DB-OC02

$ClusterAvailableDisk = @{
    Disk = $(Get-Disk -Number 4)
    ErrorAction = "SilentlyContinue"
    WarningAction = "SilentlyContinue"
    }

$AvailableDisk = Get-ClusterAvailableDisk @ClusterAvailableDisk
if($AvailableDisk)
{
    $ClusterDisk   = Add-ClusterDisk -InputObject $AvailableDisk
    $ClusterDisk.Name = "Quorum"

    $ClusterResource = @{
        Name = $ClusterDisk.Name
        Group = (Get-ClusterGroup -Name DB-OC02).Name
    }

    Move-ClusterResource @ClusterResource
}
