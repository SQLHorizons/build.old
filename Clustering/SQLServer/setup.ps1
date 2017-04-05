
$ConfigurationFile = "\\is-oc02\AllUpdatesFolder\ConfigurationFiles\DB-OC01-ConfigurationFile.ini"
$process = "$((Get-WMIObject -Class Win32_CDROMDrive).Drive)\setup.exe"

$setupArguments = @(
    "/ConfigurationFile=$ConfigurationFile"
    )

Start-Process $process -ArgumentList $setupArguments -Wait -WindowStyle Hidden 
