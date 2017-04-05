$CauClusterRole = @{
    ClusterName = "CDB-OC01"
    Force = $true
    CauPluginName = "Microsoft.WindowsUpdatePlugin"
    CauPluginArguments = @{IncludeRecommendedUpdates = "True"}
    MaxRetriesPerNode = 3
    RequireAllNodesOnline = $true
    StartDate = "23/03/2017 19:00:00"
    DaysOfWeek = 4
    WeeksOfMonth = @(3)
    UseDefault = $true
    EnableFirewallRules = $true
    }

Set-CauClusterRole @CauClusterRole;

Enable-CauClusterRole -ClusterName CDB-OC01 -Force;
