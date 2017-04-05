<#  Assign iSCSI target

The Add-IscsiVirtualDiskTargetMapping cmdlet assigns a virtual disk to an iSCSI target. Once a virtual
disk has been assigned to a target, and after the iSCSi initiator connects to that target, the iSCSI
initiator can access the virtual disk. All of the virtual disks assigned to the same iSCSI target will
be accessible by the connected iSCSI initiator.
 
    Add-IscsiVirtualDiskTargetMapping –TargetName TestTarget –Path ramdisk:test.vhdx

#>

$IscsiServerTarget = Get-IscsiServerTarget -TargetName "cdb-oc01"
$IscsiVirtualDisk = Get-IscsiVirtualDisk|Where-Object{$_.Description -eq "tLog"}

Add-IscsiVirtualDiskTargetMapping -TargetName $($IscsiServerTarget.TargetName) -Path $($IscsiVirtualDisk.Path)
