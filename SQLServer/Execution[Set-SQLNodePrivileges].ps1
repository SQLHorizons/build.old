
    $VMName     = $env:COMPUTERNAME

    [string]$SA = 'SQLSVCACCOUNT'
    $CnfgFile   = "\\library\AllSQLUpdates\ConfigurationFiles\$VMName-ConfigurationFile.ini"
    $acc        = Get-Content $CnfgFile -Encoding ascii -ErrorAction SilentlyContinue|Select-String $SA

    if ($acc)
    {
        [string]$ServiceAccount = ($acc -split ('=')).Replace("`"","")[-1]
        if($ServiceAccount)
            {Set-SQLNodePrivileges -ServiceAccount $ServiceAccount}
    }
