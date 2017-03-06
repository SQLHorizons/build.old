Function Add-FailoverClustering
{
    If (-not((Get-WindowsFeature -Name Failover-Clustering).InstallState -eq 'Installed'))
    {
        Install-WindowsFeature -Name Failover-Clustering –IncludeManagementTools
    }
}

Add-FailoverClustering
