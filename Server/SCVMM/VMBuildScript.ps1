
$Volume = "Volume3"
$VMName = "AS-OC181"
$Description = "Function: DC, Owner: Server Team, Built By Paul Maxfield, Build Date: $(Get-Date -Format dd/MM/yyyy)"
$Tag = "OCC MER1"
$size = 100

Try
{   

    $VMMServer = $env:COMPUTERNAME
    $JobGroupId = [Guid]::NewGuid().ToString()
    $Cluster = "OCCloud1"

    switch ($Tag)
    {
        "OCC MER1" {[string]$VMHost = $((Get-SCVMHostCluster $Cluster).Nodes.Computername|Where-Object {($_ -split '')[6] -eq 1})|Out-Gridview -PassThru -Title 'Select VM Host';break}
        "OCC MER2" {[string]$VMHost = $((Get-SCVMHostCluster $Cluster).Nodes.Computername|Where-Object {($_ -split '')[6] -eq 2})|Out-Gridview -PassThru -Title 'Select VM Host';break}
        default {Throw "Failed to find VMHost"}
    }

    New-ADOCCServer -VMName $VMName -Description $Description -Tag $Tag

    $Quick2012R2VM = @{
        VMMServer = $VMMServer
        VMName = $VMName
        VMHost = $VMHost
        HardwareProfile = "STORM Hardware Profile"
        Volume = $Volume
        Description = $Description
        Tag = $Tag
        }

    $JobVariable = Deploy-Quick2012R2VM @Quick2012R2VM

    while($JobVariable.Status -eq "Running")
    {
        Write-Host "Job Progress: $($JobVariable.Progress)"
        Sleep -Seconds 20
    }

    if($JobVariable.Status -eq "Completed")
    {
        #Set Preferred Owners
        Set-VMOwners -VMName $VMName

        #Resize OS Disk
        if ($size)
        {
            $ExpandDiskArguments = @{
                VMMServer = $VMMServer
                VMName = $VMName
                size = $size
                }
            Expand-VMOSDisk @ExpandDiskArguments
        }

        #Set DVD/CD to R:
        Get-WmiObject -Computer $VMName -Class Win32_volume -Filter 'DriveType=5' |
            Select-Object -First 1 |
            Set-WmiInstance -Arguments @{DriveLetter='R:'}|Out-Null

        #Install SCOM
        $PrimaryMgmtServer = Get-SCOMManagementServer -ComputerName ms-oc14.norfolk.co.uk
        Install-SCOMAgent -DNSHostName "$VMName.$env:USERDNSDOMAIN" -PrimaryManagementServer $PrimaryMgmtServer[0]

        #Refresh Virtual Machine for SCVMM console
        Read-SCVirtualMachine -VM $VMName -Force|Out-Null
    }
    else
    {
        Get-SCVMTemplate -All | where { $_.Name -like "Temporary Template*" } | Remove-SCVMTemplate
        Throw $Error[0]
    }
}
catch
{
    Throw $Error[0]
}
