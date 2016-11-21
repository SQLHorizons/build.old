# Sets local User Rights Assignment for Service Account

$ServiceAccount = "SA-DBOC52-SQLServer"

Set-SQLNodePrivileges -ServiceAccount $ServiceAccount -Verbose
