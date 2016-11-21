    cls;$Error.Clear()
    if (-not(Get-Module -name 'SQLPS'))
    {   if (Get-Module  -ListAvailable|Where-Object {$_.Name -eq 'SQLPS' })
        {   Push-Location
            Import-Module -Name 'SQLPS' -DisableNameChecking
            Pop-Location
        }
    }

    [object]$SQLServer                 = "s1"
    [long]$MinServerMemory             = 0
    [long]$MaxServerMemory             = $null
    [bool]$DefaultBackupCompression    = $true
    [long]$RemoteQueryTimeout          = 60
    [bool]$OptimizeAdhocWorkloads      = $true
    [bool]$XPCmdShellEnabled           = $true
    [bool]$IsSqlClrEnabled             = $true
    [bool]$RemoteDacConnectionsEnabled = $true

    Set-AdvancedSQLOptions -SQLServer $SQLServer -Verbose
