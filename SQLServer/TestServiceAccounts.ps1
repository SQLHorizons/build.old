# Tests and Saves Service Account Details

$SQLServer = "DB-OC45"
$SAAccounts = @("NORFOLK\SA-DBOC45-SQLServer", "NORFOLK\SA-DBOC45-SQLAgent")

foreach($SAAccount in $SAAccounts)
{
    Get-Credential -Credential $SAAccount |
    Test-ServiceAccount |
    Set-SAAccount -SQLServer $SQLServer -DatabaseServer "DB-OC13" -Database "SQLInfo"
}
