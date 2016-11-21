Function Install-SQLServices
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true)]
        [string]$DatabaseServer,
        [parameter(Mandatory = $true)]
        [string]$Database,
        [parameter(Mandatory = $true)]
        [string]$ConfigurationFile
    )
    
    $SA_Accounts = Get-SQLServiceAccounts $DatabaseServer $Database $ConfigurationFile
    
    $process = "$((Get-WMIObject -Class Win32_CDROMDrive).Drive)\setup.exe"
    $setupArguments = @(
        "/SQLSVCPASSWORD=$(($SA_Accounts | Where-Object { $_.Account -like 'SQLSVC*' }).Password)"
        "/AGTSVCPASSWORD=$(($SA_Accounts | Where-Object { $_.Account -like 'AGTSVC*' }).Password)"
        "/SAPWD=$(($SA_Accounts | Where-Object { $_.Account -like 'SQLSVC*' }).Password)"
        "/ConfigurationFile=$ConfigurationFile"
    )
    if (($SA_Accounts | Where-Object { $_.Account -like 'RSSVC*' }).Password)
    {
        $setupArguments += @("/RSSVCPASSWORD=$(($SA_Accounts | Where-Object { $_.Account -like 'RSSVC*' }).Password)")
    }
    Start-Process $process -ArgumentList $setupArguments -Wait -WindowStyle Hidden
    Start-Process -FilePath "C:\Program Files\Microsoft SQL Server\120\Setup Bootstrap\Log\Summary.txt"
}
