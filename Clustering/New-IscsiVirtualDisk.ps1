$NewIscsiVirtualDisk = @{
    Description = "tLog"
    DoNotClearData = $true
    Path = "C:\iSCSIVolumens\iSCSIVirtualDisks\DB-OC01-tLog-01.vhdx"
    SizeBytes = 15GB
    UseFixed = $false
    }

New-IscsiVirtualDisk @NewIscsiVirtualDisk
