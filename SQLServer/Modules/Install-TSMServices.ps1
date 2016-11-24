Function Install-TSMServices
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$InstallDir,
        [parameter(Mandatory = $true)]
        [string]$password
    )

    $ps1 = New-Object System.Diagnostics.Process
    $ps1.StartInfo.FileName  =  "$($InstallDir)\dsmcutil.exe"
    $ps1.StartInfo.Arguments =  " install cad"
    $ps1.StartInfo.Arguments += " /name:TSM-Client-Acceptor"
    $ps1.StartInfo.Arguments += " /optfile:$InstallDir\dsm.opt"
    $ps1.StartInfo.Arguments += " /node:$env:COMPUTERNAME"
    $ps1.StartInfo.Arguments += " /password:$password"
    $ps1.StartInfo.Arguments += " /autostart:yes"
    $ps1.StartInfo.RedirectStandardOutput = $true
    $ps1.StartInfo.WorkingDirectory = $InstallDir
    $ps1.StartInfo.UseShellExecute = $false
    $ps1.Start()
    $ps1.WaitForExit()
    $ps1.StandardOutput.ReadToEnd();

    (Get-Service).Where{ $_.Name -eq "TSM-Client-Acceptor" }|Start-Service

    $ps2 = New-Object System.Diagnostics.Process
    $ps2.StartInfo.FileName  =  "$($InstallDir)\dsmcutil.exe"
    $ps2.StartInfo.Arguments =  " install remoteagent"
    $ps2.StartInfo.Arguments += " /name:TSM-Remote-Client-Agent"
    $ps2.StartInfo.Arguments += " /optfile:$InstallDir\dsm.opt"
    $ps2.StartInfo.Arguments += " /node:$env:COMPUTERNAME"
    $ps2.StartInfo.Arguments += " /password:$password"
    $ps2.StartInfo.Arguments += " /partnername:TSM-Client-Acceptor"
    $ps2.StartInfo.RedirectStandardOutput = $true
    $ps2.StartInfo.WorkingDirectory = $InstallDir
    $ps2.StartInfo.UseShellExecute = $false
    $ps2.Start()
    $ps2.WaitForExit()
    $ps2.StandardOutput.ReadToEnd();

    (Get-Service).Where{ $_.Name -eq "TSM-Remote-Client-Agent" }|Start-Service

    $ps3 = New-Object System.Diagnostics.Process
    $ps3.StartInfo.FileName  =  "$($InstallDir)\dsmcutil.exe"
    $ps3.StartInfo.Arguments =  " install SCHEDuler"
    $ps3.StartInfo.Arguments += " /name:TSM-Backup-Scheduler"
    $ps3.StartInfo.Arguments += " /optfile:$InstallDir\dsm.opt"
    $ps3.StartInfo.Arguments += " /node:$env:COMPUTERNAME"
    $ps3.StartInfo.Arguments += " /password:$password"
    $ps3.StartInfo.Arguments += " /autostart:yes"
    $ps3.StartInfo.Arguments += " /clientdir:$InstallDir"
    $ps3.StartInfo.Arguments += " /validate:yes"
    $ps3.StartInfo.Arguments += " /startnow:no"
    $ps3.StartInfo.Arguments += " /eventlogging:no"
    $ps3.StartInfo.Arguments += " /clusternode:no"
    $ps3.StartInfo.RedirectStandardOutput = $true
    $ps3.StartInfo.WorkingDirectory = $InstallDir
    $ps3.StartInfo.UseShellExecute = $false
    $ps3.Start()
    $ps3.WaitForExit()
    $ps3.StandardOutput.ReadToEnd();
    
    (Get-Service).Where{ $_.Name -like 'TSM*' }

}

<#
$ps4 = New-Object System.Diagnostics.Process
$ps4.StartInfo.FileName  =  "$($InstallDir)\dsmcutil.exe"
$ps4.StartInfo.Arguments =  " remove"
$ps4.StartInfo.Arguments += " /name:TSM-Client-Acceptor"
$ps4.StartInfo.RedirectStandardOutput = $true
$ps4.StartInfo.WorkingDirectory = $InstallDir
$ps4.StartInfo.UseShellExecute = $false
$ps4.Start()
$ps4.WaitForExit()
$ps4.StandardOutput.ReadToEnd();

$ps5 = New-Object System.Diagnostics.Process
$ps5.StartInfo.FileName  =  "$($InstallDir)\dsmcutil.exe"
$ps5.StartInfo.Arguments =  " remove"
$ps5.StartInfo.Arguments += " /name:TSM-Remote-Client-Agent"
$ps5.StartInfo.RedirectStandardOutput = $true
$ps5.StartInfo.WorkingDirectory = $InstallDir
$ps5.StartInfo.UseShellExecute = $false
$ps5.Start()
$ps5.WaitForExit()
$ps5.StandardOutput.ReadToEnd();

$ps6 = New-Object System.Diagnostics.Process
$ps6.StartInfo.FileName  =  "$($InstallDir)\dsmcutil.exe"
$ps6.StartInfo.Arguments =  " remove"
$ps6.StartInfo.Arguments += " /name:TSM-Backup-Scheduler"
$ps6.StartInfo.RedirectStandardOutput = $true
$ps6.StartInfo.WorkingDirectory = $InstallDir
$ps6.StartInfo.UseShellExecute = $false
$ps6.Start()
$ps6.WaitForExit()
$ps6.StandardOutput.ReadToEnd();
#>