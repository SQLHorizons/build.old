    # Install TSM BA Client

    $TSMparameters = @{
        TSMSoftware = "\\library\AllSQLUpdates\TSMClient"
        InstallDir  = "T:\Data_X\tivoli\tsm\baclient"
        password    = "tsm"
        Verbose     = $true
    }

    $start    = Get-Date
    Install-TSMBAClient @TSMparameters
    Write-Host -ForegroundColor Red ("Total Runtime: $(((Get-Date) - $start).TotalMinutes) minutes")
