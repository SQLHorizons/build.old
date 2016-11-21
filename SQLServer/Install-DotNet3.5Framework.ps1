# Installs 3.5 .Net Framework

If ((Get-WindowsFeature -Name NET-Framework-Core).InstallState -eq 'Removed')
{
    Install-WindowsFeature Net-Framework-Core -Source '\\library\sxs'
}