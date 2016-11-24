# Setup of Advanced SQL Options

$AdvancedParameters = @{
    SQLServer                    = $env:COMPUTERNAME;
    MinServerMemory              = 0;
    MaxServerMemory              = $null;
    DefaultBackupCompression     = $true;
    RemoteQueryTimeout           = 60;
    OptimizeAdhocWorkloads       = $true;
    XPCmdShellEnabled            = $true;
    IsSqlClrEnabled              = $true;
    RemoteDacConnectionsEnabled  = $true;    
    }

Set-AdvancedSQLOptions @AdvancedParameters -Verbose
