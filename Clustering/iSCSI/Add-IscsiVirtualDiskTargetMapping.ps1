$IscsiServerTarget = Get-IscsiServerTarget -TargetName "cdb-oc01"
$IscsiVirtualDisk = Get-IscsiVirtualDisk|Where-Object{$_.Description -eq "tLog"}

Add-IscsiVirtualDiskTargetMapping -TargetName $($IscsiServerTarget.TargetName) -Path $($IscsiVirtualDisk.Path)
