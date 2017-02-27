Function Set-SCVMIPAddressMode
{
    <#
    .SYNOPSIS
    Switch From Dynamic IP To Static IP Pool.

    .DESCRIPTION
    Switch From Dynamic IP To Static IP Pool in Virtual Machine Manager.

    .NOTES
    File Name : Set-SCVMIPAddressMode.ps1
    Author    : Charbel Nemnom
    Date      : 01-Mar-2016
    Version   : 1.0
    Requires  : PowerShell Version 3.0 or above, VMM IP Pools defined
    OS        : Windows Server 2012 R2 with System Center Virtual Machine Manager 2012 R2

    .LINK
    To provide feedback or for further assistance please visit:
    https://charbelnemnom.com

    .EXAMPLE
    ./Set-SCVMIPAddressMode -VMMServer &lt;VMMServerName&gt; -VM &lt;VMName&gt;
    This example will switch &lt;VMName&gt; from Dynamic IP to Static IP Pool and assign a static IP Address 
    #>

    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
    [Parameter(Mandatory=$true, HelpMessage='VMM Server Name')]
    [Alias('VMMServer')]
    [String]$VMMServerName,

    [Parameter(Mandatory=$true, HelpMessage='Virtual Machine Name')]
    [Alias('VM')]
    [String]$VMName   
    )

    $VM = Get-SCVirtualMachine -Name $VMName

    # Select The VM Network  
    $VMNetwork = Get-SCVMNetwork -VMMServer $VMMServerName | Out-Gridview -PassThru -Title 'Select VM Network'

    # Select the VM Subnet
    #$VMSubnet = Get-SCVMSubnet -VMMServer $VMMServerName -VMNetwork $VMNetwork | Out-GridView -PassThru -Title 'Select VM Subnet'

    # Select the IP Address Pool
    $IPPool = Get-SCStaticIPAddressPool -VMMServer $VMMServerName <#-VMSubnet $VMSubnet#> | Out-GridView -PassThru -Title 'Select IP Address Pool'

    # Select which Virtual NIC you want to apply Static IP Mode
    $NIC = Get-SCVirtualNetworkAdapter -VMMServer $VMMServerName -VM $VM.Name | Out-Gridview -PassThru -Title 'Select VMs vNIC'

    # Get free IP address from the IP Pool
    $IPAddress = Grant-SCIPAddress -GrantToObjectType VirtualNetworkAdapter -GrantToObjectID $VM.VirtualNetworkAdapters[($NIC.SlotID)].ID -StaticIPAddressPool $IPPool -Description $VM.Name

    # Allocate to the vmNIC an IP Address from the IP Pool
    Set-SCVirtualNetworkAdapter -VMMServer $VMMServerName -VirtualNetworkAdapter $VM.VirtualNetworkAdapters[($NIC.SlotID)] -VMNetwork $VMNetwork -IPv4AddressType Static -IPv4Addresses $IPAddress.Address
}
