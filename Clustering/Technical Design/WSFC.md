# WINDOWS SERVER FAILOVER CLUSTERING
Windows Server Failover Clustering provides infrastructure features that support the high-availability and disaster recovery scenarios of hosted server applications. If a cluster node or service fails, the services that were hosted on that node can be automatically or manually transferred to another available node in a process known as failover.
The nodes in the WSFC cluster work together to collectively provide these types of capabilities:
  * Distributed metadata and notifications.
  * Resource management.
  * Health monitoring.
  * Failover coordination.
## Cluster Active Directory Objects
When a WSFC is first created its name is registered as the cluster computer within the Active Directory, if you specify a NetBIOS name for the cluster, the Cluster Name Object (CNO) is created in the same location where the computer objects for the cluster nodes reside.  To specify a different location for the CNO, enter the distinguished name of the Organisational Unit (OU) in the **Cluster Name** box. Use the following distinguished name to register the CNO:
