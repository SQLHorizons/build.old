Function Set-SQLtempdbfiles
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object]$SQLServer,
        [parameter(Mandatory = $true)]
        [double]$DataSize,
        [parameter(Mandatory = $true)]
        [double]$tLogSize
    )

    $cpuNo    = (Get-WmiObject -ComputerName $SQLServer -Class Win32_ComputerSystem -ErrorAction Stop).NumberOfLogicalProcessors; 
    if($cpuNo -gt 8) {$cpuNo = 8};

    $srvobj   = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Server($SQLServer)
    $tempdb   = $srvobj.Databases.Item('tempdb').FileGroups.Item('PRIMARY')
    $tLog     = $srvobj.Databases.Item('tempdb').LogFiles.Item('templog')

    $id = 1
    while($id -le $cpuNo)
    {
        if($id -ne 1){$fileid = $id +1}else{$fileid = $id}
        Write-Verbose "Working on file id: $($fileid), file $("tempdev0$id")..."
        $file = $tempdb.Files.ItemById($fileid)

        if($file)
        {   
            if($file.Name -ne "tempdev0$id"){$file.Rename("tempdev0$id")}
            Write-Verbose "Alter file '$($file.Name)'; Set file size to $($DataSize/($cpuNo*1KB))...'"
        }
        else
        {
            $file = New-Object -TypeName Microsoft.SqlServer.Management.SMO.DataFile($tempdb, "tempdev0$id")
            Write-Verbose "Create file '$($file.Name)'; Set file size to $($DataSize/($cpuNo*1KB))...'"
            $file.FileName = "$($tempdb.Parent.PrimaryFilePath)\$("tempdev0$id").ndf"
            $file.Create()
        }
        if($file.Size       -ne $DataSize/($cpuNo*1KB))   {$file.Size       = $DataSize/($cpuNo*1KB)}  ###
        if($file.GrowthType -ne "none")                   {$file.GrowthType = "none"}
        $file.Alter()
        $id += 1
    }

    Write-Verbose "Working on log file id: $($tLog.ID), file $($tLog.Name)..."
    $tLog.Size       = $tLogSize/1KB
    $tLog.GrowthType = "none"
    $tLog.Alter()
}