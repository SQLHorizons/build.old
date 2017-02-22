Function Get-VirtualNetworkAdapterArguments
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true)]
        [string]$VMMServer,
        [parameter(Mandatory = $true)]
        [guid]$JobGroupId
    )
    Try
    {
        $Arguments = @{
            VMMServer = $VMMServer
            JobGroup = $JobGroupId
            MACAddressType = "Dynamic"
            VLanEnabled = $false
            Synthetic = $true
            EnableVMNetworkOptimization = $false
            EnableMACAddressSpoofing = $false
            EnableGuestIPNetworkVirtualizationUpdates = $false
            IPv4AddressType = "Dynamic"
            IPv6AddressType = "Dynamic"
            }
        Return $Arguments
    }
    Catch
    {
        Throw $Error
    }
}

Get-VirtualNetworkAdapterArguments -VMMServer $env:COMPUTERNAME -JobGroupId $([Guid]::NewGuid().ToString())
