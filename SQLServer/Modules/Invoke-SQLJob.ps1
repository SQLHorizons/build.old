 Function Invoke-SQLJob
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true)]
        [string]$sqlServer,
        [parameter(Mandatory = $true)]
        [string]$SQLjob
    )

    $server    = New-Object Microsoft.SqlServer.Management.Smo.Server($sqlServer)
    $SQLAgent  = $server.JobServer
    $jobObject = $SQLAgent.Jobs.Item($SQLjob)
    Write-Verbose "About to run SQL Agent job $($jobObject.Name)..."
    $jobObject.Invoke()
    Write-Verbose "SQL Agent job $($jobObject.LastRunOutcome)"
    Return $jobObject
}
