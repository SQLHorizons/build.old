Function New-SQLServiceAccounts
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Server,
        [parameter(Mandatory = $true)]
        [string]$AccountOU,
        [parameter(Mandatory = $true)]
        [string]$dnsDomain,
        [parameter(Mandatory = $true)]
        [pscredential]$Credential
    )
    
    foreach ($SAAccount in @("SA-$($Server.Replace('-', ''))-SQLServer", "SA-$($Server.Replace('-', ''))-SQLAgent"))
    {
        $NewADUserparameters = @{
            Enabled = $true
            Name = $SAAccount
            GivenName = $SAAccount
            DisplayName = $SAAccount
            SamAccountName = $SAAccount
            UserPrincipalName = "$($SAAccount.ToLower())@$dnsDomain"
            Description = "SQL Service Account"
            Path = $AccountOU
            AccountPassword = $(Read-Host -AsSecureString "AccountPassword")
            CannotChangePassword = $true
            PasswordNeverExpires = $true
            Credential = $Credential
            PassThru = $true
        }
        
        $Account = New-ADUser @NewADUserparameters
        
        if ($Account.Name.Split("-")[-1] -eq "SQLServer")
        {
            $SPNModifyparameters = @{
                Credential = $Credential
                Account = $Account
            }
            Grant-SPNModify @SPNModifyparameters
        }
    }
}
