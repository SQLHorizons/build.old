
    $SQLparameters = @{
        Server             = "s1"
        Database           = "SQLInfo"
        IntegratedSecurity = $true
        Verbose            = $true
    }

    $SqlConnection = Get-SQLConnection @SQLparameters