
$SAAccount  = "NORFOLK\SA-DBOC52-SQLServer"
Get-Credential -Credential $SAAccount|
        Get-SAAccount -DatabaseServer "S1" -Database "SQLInfo" -Verbose