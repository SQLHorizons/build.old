$TSMSoftware = "\\library\AllSQLUpdates\TSMClient"

$TSMSWfiles  = "$($TSMSoftware)\TSM_BA_Client_7.1.6.2_WinX64"
$TEMPfiles   = "$($env:TEMP)\TSM_BA_Client"

$copyparameters = @{
    Source = $TSMSWfiles
    Destination = $TEMPfiles
    Verbose = $true
}

Copy-Folder @copyparameters
