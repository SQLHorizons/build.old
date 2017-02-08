$Credential = Get-Credential
$sccmClient = "\\ms-oc31.$($env:USERDNSDOMAIN.ToLower())\sms_cm1\Client"
$process    = "P:\ccmsetup.exe"

try
{
    New-PSDrive -Name P -PSProvider FileSystem -Root $sccmClient -Credential $Credential

    Write-Host "Install SCCM Client..."
    Start-Process $process -Wait -WindowStyle Hidden
    if(Get-ControlPanelItem -Name "Configuration Manager")
    {
        Write-Host "SCCM Client Installed Successfully..."
        #Show-ControlPanelItem "Configuration Manager"
    }
    else
    {
        Throw "Failed to install SCCM Client"
    }

    Push-Location "$($env:windir)\ccmsetup"

    $ccmsetup = ".\ccmsetup.exe"
    $Arguments = @(
        "SMSSITECODE=CM1"
        "FSP=MS-OC33.$($env:USERDNSDOMAIN.ToLower())"
    )

    Start-Process $ccmsetup -ArgumentList $Arguments -Wait -WindowStyle Hidden
}
catch
{
    Throw "SCCM Client install has failed, resolve issues before retrying..."
}
