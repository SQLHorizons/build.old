Function Get-SQLServiceAccounts
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
    
    $SA_Accounts = $null
    
    foreach ($value in 'SQLSVCACCOUNT', 'AGTSVCACCOUNT', 'RSSVCACCOUNT')
    {
        $SAAccount = (Get-Content $ConfigurationFile -Encoding ascii | Select-String $value)
        
        if ($SAAccount)
        {
            $tmptbl = @{
                Account = $value;
                Password = Get-SAAccount -SACredential $SAAccount -DatabaseServer $DatabaseServer -Database $Database
            }
            [Array]$SA_Accounts += New-Object PSObject -Property $tmptbl
        }
    }
    Return $SA_Accounts
}
