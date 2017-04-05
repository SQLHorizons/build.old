#Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue

$library = "\\library\PoSh$\00_Builds\00_Server"
Push-Location -Path $library

Push-Location -Path "$library\Modules"
foreach($module in Get-ChildItem)
{
    Import-Module ".\$module"
}
Pop-Location

$dns = $($env:USERDNSDOMAIN.ToLower())

$SAparameters = @{
    Server = $(Read-Host "SQL Server Name")
    Credential = Get-Credential
    AccountOU = "OU=SQL,OU=SERVICE ACCOUNTS,DC=SQLHorizons,DC=com"
    dnsDomain = $dns
}

New-SQLServiceAccounts @SAparameters -Verbose
