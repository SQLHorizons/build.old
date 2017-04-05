$SAparameters = @{
    Server = "DB-OC60"
    Credential = Get-Credential
    AccountOU = "OU=SQL,OU=SERVICE ACCOUNTS,DC=sqlhorizons,DC=com"
}

New-SQLServiceAccounts @SAparameters
