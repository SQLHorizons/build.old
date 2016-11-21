# Set Trust this user for delegation to any service, run by Domain Admins only

$parameters = @{
    ServiceAccount = "SA-DBOC45-SQLServer"
    Credential = "NORFOLK\ncAdmin02"
    Verbose = $true
}

Set-ADDelegationTrust @parameters
