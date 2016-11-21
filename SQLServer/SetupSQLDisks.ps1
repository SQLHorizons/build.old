# Setup SQL Server disks

$configfile = "\\library\AllSQLUpdates\ConfigurationFiles\default-disks.csv"

Set-ServerDisks -configfile $configfile -Verbose

# Setup SQL directories

$SQLdirectories = "T:\Data_X\diag_01","T:\Data_X\FTData","T:\Data_X\oracle","T:\Data_X\Packages","T:\Data_X\PoSh","T:\Data_X\tivoli"

New-DirectorySet -directories $SQLdirectories -Verbose