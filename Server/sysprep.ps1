$Credential = Get-Credential
$sccmClient = "\\ms-oc31.sqlhorizons.com\sms_cm1\Client"
$process    = "P:\ccmsetup.exe"
$avservs    = "Sophos Message Router", "Sophos Agent", "Sophos AutoUpdate Service"
$Sophos     = "HKLM:\SOFTWARE\Wow6432Node\Sophos"
$rPaths     = ".\Messaging System\Router\Private", ".\Remote Management System\ManagementAgent\Private"
$keys       = "pkc", "pkp"
$machineID  = "C:\ProgramData\Sophos\AutoUpdate\data\machine_ID.txt"

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

    foreach($avserv in $avservs)
    {
        Write-Host "Stopping Sophos Serveices..."
        Get-Service -Name $avserv|Stop-Service|Out-Null
    }

    Push-Location -Path $Sophos
    foreach($rPath in $rPaths)
    {
        foreach($key in $keys)
        {
            Write-Host "Deleting Sophos registry key $($key) from $($rPath)..."
            Remove-ItemProperty -Path $rPath -Name $key -ErrorAction SilentlyContinue
        }
    }
    Pop-Location

    if(Test-Path $machineID)
    {
        Write-Host "Removing Sophos MachineID..."
        Remove-Item $machineID -Force
        if(Test-Path $machineID)
        {
            Throw "Failed to remove Sophos MachineID..."
        }
    }
        
    Write-Host "About to run sysprep..."
    pause

    Push-Location "$($env:windir)\system32"

    $sysprep = ".\sysprep\sysprep.exe"
    $Arguments = @(
        "/generalize"
        "/shutdown"
        "/oobe"
        "/mode:vm"
    )

    Start-Process $sysprep -ArgumentList $Arguments -Wait -WindowStyle Hidden

}
catch
{
    Throw "sysprep process has failed, resolve issues before retrying..."
}
