Set-Service WinRM -StartupType Automatic -PassThru | Start-Service
Set-WSManQuickConfig -Force
$winrm = "winrm"
$ip = '"10.7.173.222"'

Start-Process $winrm -ArgumentList quickconfig -Wait -WindowStyle Hidden

$Arguments = @(
    "set winrm/config/client @{TrustedHosts=$ip}"
)

Start-Process $winrm -ArgumentList $Arguments -Wait -WindowStyle Hidden
Start-Process chcp -ArgumentList 65001 -Wait -WindowStyle Hidden
