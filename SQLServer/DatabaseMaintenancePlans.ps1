#Deploy MaintenancePlans

$filepath = "\\library\AllSQLUpdates\T-SQL\ola.hallengren"

$dbMainPlans = "$($filepath)\MaintenanceSolution.sql"
$restoreDBs  = "$($filepath)\RestoreAllDatabases-sp.sql"

New-fn_SQLServerBackupDir -Verbose

$DMPparameters = @{
    SQLServer = $env:COMPUTERNAME
    files = @($dbMainPlans, $restoreDBs)
    Verbose = $true
}

Install-DatabaseMaintenancePlans @DMPparameters