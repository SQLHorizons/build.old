     $Jobparameters = @{
        sqlServer = "ADBServer"
        SQLjob    = "Test"
        Verbose   = $true
    }

    $Job = Invoke-SQLJob @Jobparameters
    $Job.EnumHistory()
