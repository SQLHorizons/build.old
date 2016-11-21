    # Install SQL Services

    $parameters = @{
        DatabaseServer = "DB-OC13"
        Database = "SQLInfo"
        ConfigurationFile = "\\library\AllSQLUpdates\ConfigurationFiles\$($env:COMPUTERNAME)-ConfigurationFile.ini"
    }

    Install-SQLServices @parameters
    pause
    Restart-Computer -Force