<#  New iSCSI Vitrual Disk

The New-IscsiVirtualDisk cmdlet creates a new iSCSI Virtual Hard Disk (VHDX) object with the specified
file path and size. After the iSCSI VHDX object has been created, the virtual disk can be assigned to
an iSCSI target. Once a virtual disk has been assigned to a target, and an initiator connects to that
target, the iSCSI initiator can then access the virtual disk after the initiator connects to the target.
 
    New-IscsiVirtualDisk –Path ramdisk:test.vhdx –Size 20MB
#>

    $NewIscsiVirtualDisk = @{
        Description = "tLog"
        DoNotClearData = $true
        Path = "C:\iSCSIVolumens\iSCSIVirtualDisks\DB-OC01-tLog-01.vhdx"
        SizeBytes = 15GB
        UseFixed = $false
        }

    New-IscsiVirtualDisk @NewIscsiVirtualDisk
