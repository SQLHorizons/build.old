#   Note, this function assumes a certain pattern of name is use for identifying owners,
#   is this instance the owner names were like VM-OC101, VM-OC103, & VM-OC201.

Function Set-VMOwners
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true)]
        [string]$VMName
    )

    if($VMName.Length -le 8)
    {
        switch ($VMName.Split("-")[1].Substring(0,2))
        {
            "DE"{break}
            "MA"{break}
            "OC"
            {
                $resource = Get-ClusterGroup -Cluster "OCCloud1"|Where-Object {$_.Name -like "*$VMName*"};
                switch -Wildcard (($resource.ownernode -split '')[6])
                {
                    "1"
                    {
                        Set-ClusterOwnerNode -InputObject $resource -Owners $((Get-SCVMHostCluster -Name "OCCloud1").Nodes.Computername|
                            Where-Object {($_ -split '')[6] -eq 1});
                        break
                    }
                    "2"
                    {
                        Set-ClusterOwnerNode -InputObject $resource -Owners $((Get-SCVMHostCluster -Name "OCCloud1").Nodes.Computername|
                            Where-Object {($_ -split '')[6] -eq 2});
                        break
                    }
                }
            }
            default {Throw "Failed to find OU for VMHost $VMName"}
        }
    }

    Read-SCVirtualMachine -VM $VMName -Force|Out-Null
}

Set-VMOwners -VMName "AS-OC181"
