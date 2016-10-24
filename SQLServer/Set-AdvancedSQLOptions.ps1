function Set-AdvancedSQLOptions
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]

    param

    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object]$SQLServer,
        [long]$MinServerMemory             = 0,
        [long]$MaxServerMemory             = $null,
        [bool]$DefaultBackupCompression    = $true,
        [long]$RemoteQueryTimeout          = 60,
        [bool]$OptimizeAdhocWorkloads      = $true,
        [bool]$XPCmdShellEnabled           = $true,
        [bool]$IsSqlClrEnabled             = $true,
        [bool]$RemoteDacConnectionsEnabled = $true
    ) 

    try
    {
        Write-Verbose "Configuring SQL Server Advanced Options for '$($SQLServer)'"
        $srvobj   = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Server($SQLServer)
        $server   = Get-WmiObject -ComputerName $SQLServer -Class Win32_ComputerSystem -ErrorAction Stop
        if(!$MaxServerMemory){$MaxServerMemory   = [Math]::Round(($server.TotalPhysicalMemory*0.8241)/1MB, 0)};

        $srvobj.Configuration.ShowAdvancedOptions.ConfigValue             = 1

        if ($srvobj.Configuration.MinServerMemory.ConfigValue -ne $MinServerMemory)
        {
            Write-Verbose "Setting Minimum server memory to $($MinServerMemory)..."
            $srvobj.Configuration.MinServerMemory.ConfigValue             = $MinServerMemory
        }

        if ($srvobj.Configuration.MaxServerMemory.ConfigValue -ne $MaxServerMemory)
        {
            Write-Verbose "Setting Maximum server memory to $($MaxServerMemory)..."
            $srvobj.Configuration.MaxServerMemory.ConfigValue             = $MaxServerMemory
        }

        if ($srvobj.Configuration.DefaultBackupCompression.ConfigValue -ne $DefaultBackupCompression)
        {
            Write-Verbose "Setting Default Backup Compression to $($DefaultBackupCompression)..."
            $srvobj.Configuration.DefaultBackupCompression.ConfigValue    = $DefaultBackupCompression
        }

        if ($srvobj.Configuration.RemoteQueryTimeout.ConfigValue -ne $RemoteQueryTimeout)
        {
            Write-Verbose "Setting Remote Query Timeout to $($RemoteQueryTimeout)..."
            $srvobj.Configuration.RemoteQueryTimeout.ConfigValue          = $RemoteQueryTimeout
        }

        if ($srvobj.Configuration.OptimizeAdhocWorkloads.ConfigValue -ne $OptimizeAdhocWorkloads)
        {
            Write-Verbose "Setting Optimize Adhoc Workloads to $($OptimizeAdhocWorkloads)..."
            $srvobj.Configuration.OptimizeAdhocWorkloads.ConfigValue      = $OptimizeAdhocWorkloads
        }

        if ($srvobj.Configuration.XPCmdShellEnabled.ConfigValue -ne $XPCmdShellEnabled)
        {
            Write-Verbose "Setting XPCmdShell Enabled to $($XPCmdShellEnabled)..."
            $srvobj.Configuration.XPCmdShellEnabled.ConfigValue           = $XPCmdShellEnabled
        }

        if ($srvobj.Configuration.IsSqlClrEnabled.ConfigValue -ne $IsSqlClrEnabled)
        {
            Write-Verbose "Setting is SQL CLR Enabled to $($IsSqlClrEnabled)..."
            $srvobj.Configuration.IsSqlClrEnabled.ConfigValue             = $IsSqlClrEnabled
        }

        if ($srvobj.Configuration.RemoteDacConnectionsEnabled.ConfigValue -ne $RemoteDacConnectionsEnabled)
        {
            Write-Verbose "Setting Remote DAC Connections Enabled to $($RemoteDacConnectionsEnabled)..."
            $srvobj.Configuration.RemoteDacConnectionsEnabled.ConfigValue = $RemoteDacConnectionsEnabled
        }

        $srvobj.Configuration.ShowAdvancedOptions.ConfigValue             = 0
        $srvobj.Alter()
    }
    catch
    {
        $message = $_.Exception.Message
        Throw "SQL Server configuration Set-AdvancedSQLOptions failed with the following error: '$($message)'"
    }
}
