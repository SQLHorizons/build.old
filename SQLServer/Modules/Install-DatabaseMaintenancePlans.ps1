Function Install-DatabaseMaintenancePlans
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true)]
        [object]$SQLServer,
        [parameter(Mandatory = $true)]
        [object]$files
    )
    
    Get-SQLPSModule
    
    foreach ($file in $files)
    {
        Invoke-Sqlcmd -InputFile $file -ServerInstance $SQLServer -ConnectionTimeout 300
    }
    
    $jobs = @('SQLOPs - CommandLog Cleanup'
         , 'SQLOPs - DatabaseBackup - SYSTEM_DATABASES - FULL'
         , 'SQLOPs - DatabaseBackup - USER_DATABASES - FULL'
         , 'SQLOPs - DatabaseBackup - USER_DATABASES - DIFF'
         , 'SQLOPs - DatabaseBackup - USER_DATABASES - LOG'
         , 'SQLOPs - DatabaseIntegrityCheck - SYSTEM_DATABASES'
         , 'SQLOPs - DatabaseIntegrityCheck - USER_DATABASES'
         , 'SQLOPs - IndexOptimize - USER_DATABASES'
         , 'SQLOPs - Output File Cleanup'
         , 'SQLOPs - sp_delete_backuphistory'
         , 'SQLOPs - sp_purge_jobhistory'
         , 'syspolicy_purge_history'
    )
    
    foreach ($job in $jobs)
    {
        $command += "EXEC [msdb].[dbo].[sp_start_job] N'$job'"
        Write-Host $command
        Invoke-Sqlcmd $command -Database 'msdb' -ServerInstance $SQLServer
        Start-Sleep -Milliseconds 1500
        $command = $null
    }
}
