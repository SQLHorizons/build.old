Function Set-VMProfile
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$VMMServer
    )

    $Arguments = @{
        VMMServer = $VMMServer
        CPUType = Get-SCCPUType -VMMServer $VMMServer | where {$_.Name -eq "3.60 GHz Xeon (2 MB L2 cache)"}
        Name = "Hardware Profile"
        Description = "Profile used to create a VM/Template for Server builds"
        CPUCount = 2
        MemoryMB = 2048
        DynamicMemoryEnabled = $true
        DynamicMemoryMinimumMB = 1024
        DynamicMemoryMaximumMB = 4096
        DynamicMemoryBufferPercentage = 20
        MemoryWeight = 5000
        CPUExpectedUtilizationPercent = 20
        DiskIops = 0
        CPUMaximumPercent = 100
        CPUReserve = 0
        NumaIsolationRequired = $false
        NetworkUtilizationMbps = 0
        CPURelativeWeight = 100
        HighlyAvailable = $true
        HAVMPriority = 2000
        DRProtectionRequired = $false
        SecureBootEnabled = $true
        CPULimitFunctionality = $false
        CPULimitForMigration = $false
        Generation = 2
        }

    New-SCHardwareProfile @Arguments

}
