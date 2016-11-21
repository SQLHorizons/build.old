function Get-ActiveDirectoryModle
{
    
    if (-not (Get-Module -name 'ActiveDirectory'))
    {
        if (-not (Get-Module -ListAvailable | Where-Object { $_.Name -eq 'ActiveDirectory' }))
        {
            Push-Location
            Add-WindowsFeature RSAT-AD-PowerShell | Out-Null
            Import-Module -Name 'ActiveDirectory' -DisableNameChecking
            Pop-Location
        }
        else
        {
            Push-Location
            Import-Module -Name 'ActiveDirectory' -DisableNameChecking
            Pop-Location
        }
    }
}