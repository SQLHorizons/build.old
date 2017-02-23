Function Expand-VMOSDisk
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true)]
        [string]$VMMServer,
        [parameter(Mandatory = $true)]
        [string]$VMName,
        [parameter(Mandatory = $true)]
        [Uint32]$size
    )

    $JobGroup = [Guid]::NewGuid().ToString()

    $VirtualMachine = Get-SCVirtualMachine -VMMServer $VMMServer -Name $VMName
    $VirtualDiskDrive = Get-SCVirtualDiskDrive -VM $VirtualMachine | Where-Object {$_.Bus -eq 0 -and $_.Lun -eq 0}

    Expand-SCVirtualDiskDrive -VirtualDiskDrive $VirtualDiskDrive -VirtualHardDiskSizeGB $size -JobGroup $JobGroup
    Set-SCVirtualMachine -VM $VirtualMachine -Name $VMName -JobGroup $JobGroup -JobVariable "JobVariable"

    Return $JobVariable
}

$ExpandDiskArguments = @{
    VMMServer = $env:COMPUTERNAME
    VMName = "AS-OC183"
    size = 100
    }
Expand-VMOSDisk @ExpandDiskArguments
