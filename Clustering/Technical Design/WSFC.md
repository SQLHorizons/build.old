# WINDOWS SERVER FAILOVER CLUSTERING
Windows Server Failover Clustering provides infrastructure features that support the high-availability and disaster recovery scenarios of hosted server applications. If a cluster node or service fails, the services that were hosted on that node can be automatically or manually transferred to another available node in a process known as failover.
The nodes in the WSFC cluster work together to collectively provide these types of capabilities:
  * Distributed metadata and notifications.
  * Resource management.
  * Health monitoring.
  * Failover coordination.
## Cluster Active Directory Objects
When a WSFC is first created its name is registered as the cluster computer within the Active Directory, if you specify a NetBIOS name for the cluster, the Cluster Name Object (CNO) is created in the same location where the computer objects for the cluster nodes reside.  To specify a different location for the CNO, enter the distinguished name of the Organisational Unit (OU) in the **Cluster Name** box. Use the following distinguished name to register the CNO: *CN=ClusterName, OU=Clusters, DC=Contoso, DC=com*.

To ensure that this action is successful the logged on account must be either a member of **Domain Admins** or given the **Create Computer Objects** and **Read All Properties** permissions in the OU of the Cluster Nodes.
Once the cluster has been created ensure the CNO also has the **Create Computer Objects** and **Read All Properties** permissions in the OU.
## Quorum Mode
For a Windows Server Failover Cluster to preform appropriately it relies on a quorum-based approach to monitor overall cluster health and maximize node-level fault tolerance.  Wherein the overall health and status of the cluster is determined by a periodic quorum vote. The presence of a quorum means that the cluster is healthy and able to provide node-level fault tolerance.

Best practices for an even number of voting nodes is to use the **Node and File Share Majority** quorum mode.  This is dependent on a remote file share configured as a voting witness.  Ideally this file share should be in an alternative location to the A, and B nodes of the Cluster.
The table below details the configuration of the file share witness:
