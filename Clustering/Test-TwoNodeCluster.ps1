Function Test-TwoNodeCluster
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$NodeA,
        [parameter(Mandatory = $true)]
        [string]$NodeB,
        [parameter(Mandatory = $true)]
        [string]$clusterName
    )

    $report = Test-Cluster -Node $NodeA, $NodeB
    if ($report.FullName){Invoke-Item $report.FullName}
}

$TwoNodeCluster = @{
    NodeA = "cdb-oc01a.norfolk.police.uk"
    NodeB = "cdb-oc01b.norfolk.police.uk"
    clusterName = "CDB-OC01"
    }

Test-TwoNodeCluster @TwoNodeCluster
