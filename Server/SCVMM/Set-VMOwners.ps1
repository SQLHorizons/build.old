Function Set-VMOwners
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true)]
        [string]$VMName,
        [string]$Cluster = "OCCloud1"
    )

    $resource = Get-ClusterGroup -Cluster $Cluster|
        Where-Object {$_.Name -like "*$VMName*"}

    switch -Wildcard (($resource.ownernode -split '')[6])
    {
        "1" {Set-ClusterOwnerNode -InputObject $resource -Owners $((Get-SCVMHostCluster -Name $Cluster).Nodes.Computername|Where-Object {($_ -split '')[6] -eq 1});break}
        "2" {Set-ClusterOwnerNode -InputObject $resource -Owners $((Get-SCVMHostCluster -Name $Cluster).Nodes.Computername|Where-Object {($_ -split '')[6] -eq 2});break}
        default {Throw "Failed to find owners"}
    }

    Read-SCVirtualMachine -VM $VMName -Force|Out-Null
}

Set-VMOwners -VMName "AS-OC181"
