# Setup of temporary database files

<#
$cpuNo    = (Get-WmiObject -Class Win32_ComputerSystem).NumberOfLogicalProcessors;
if($cpuNo -gt 8) {$cpuNo = 8};
$disk     =  Get-WmiObject -Class Win32_Volume|Where-object {$_.Name -like '*tempdb_01*'};
$fileSize = [Math]::Round((($disk.Capacity*0.7)/1 -10MB)/1MB, 0);
$tLogSize = [Math]::Round((($disk.Capacity*0.7)/$cpuNo -10MB)/1MB, 0)*$cpuNo*0.1;
#>


$tempdbParameters = @{
    SQLServer = $env:COMPUTERNAME;
    DataSize  = 800MB;
    tLogSize  = 950MB;
}

Set-SQLtempdbfiles @tempdbParameters -Verbose