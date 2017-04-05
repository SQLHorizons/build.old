$ImportIscsiVirtualDisk = @{
    Description = "tLog"
    Path = "C:\iSCSIVolumens\iSCSIVirtualDisks\DB-OC01-tLog-01.vhdx"
    }

Import-IscsiVirtualDisk @ImportIscsiVirtualDisk
