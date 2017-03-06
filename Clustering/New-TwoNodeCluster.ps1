Function New-TwoNodeCluster
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$NodeA,
        [parameter(Mandatory = $true)]
        [string]$NodeB,
        [parameter(Mandatory = $true)]
        [string]$clusterName,
        [parameter(Mandatory = $true)]
        [string]$StaticAddress
    )

    $Cluster = New-Cluster -Name $clusterName -Node $NodeA, $NodeB -StaticAddress $StaticAddress
    Return $Cluster
}

$TwoNodeCluster = @{
    NodeA = "cdb-oc01a.norfolk.uk"
    NodeB = "cdb-oc01b.norfolk.uk"
    clusterName = "CDB-OC01"
    StaticAddress = "10.34.81.20"
    }

New-TwoNodeCluster @TwoNodeCluster
