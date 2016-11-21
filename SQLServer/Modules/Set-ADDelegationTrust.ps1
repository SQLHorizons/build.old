Function Set-ADDelegationTrust
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object]$ServiceAccounts,
        [parameter(Mandatory = $true)]
        [pscredential]$Credential
    )
    
    Get-ActiveDirectoryModle
    if (Test-IsInRole -Role "Domain Admins" -Credential $Credential)
    {
        foreach ($ServiceAccount in $ServiceAccounts)
        {
            $searcher = New-Object System.DirectoryServices.DirectorySearcher([ADSI]'')
            $searcher.Filter = "(&(objectClass=User)(samAccountName=$ServiceAccount))"
            $i = $searcher.FindOne()
            if ($i)
            {
                $ADfilter = "Name -eq `"$ServiceAccount`""
                Get-ADUser -Filter $ADfilter |
                Set-ADAccountControl -TrustedForDelegation $true -Credential $Credential
            }
            else { Write-Verbose "$ServiceAccount not in AD" }
        }
    }
}
