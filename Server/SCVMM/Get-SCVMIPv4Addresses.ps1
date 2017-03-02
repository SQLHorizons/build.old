Function Get-SCVMIPv4Addresses
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true)]
        [string]$VMMServer,
        [parameter(Mandatory = $true)]
        [string]$VMName
    )

    $VirtualMachine = Get-SCVirtualMachine -VMMServer $VMMServer -Name $VMName
    Return (Get-SCVirtualNetworkAdapter -VMMServer $VMMServer -VM $VirtualMachine)[0].IPv4Addresses
}
