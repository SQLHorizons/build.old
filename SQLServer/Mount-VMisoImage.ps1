Function Mount-VMisoImage
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object]$VMName,
        [parameter(Mandatory = $true)]
        [string]$VMManager,
        [parameter(Mandatory = $true)]
        [string]$isoImage
    )
    
    $VirtualDVDDrive = Get-SCVirtualDVDDrive -VMMServer $VMManager -All | Where-Object { $_.Name -eq $VMName }
    $ISO = Get-SCISO -VMMServer $VMManager | Where-Object { $_.Name -eq $isoImage }
    
    Set-SCVirtualDVDDrive -VirtualDVDDrive $VirtualDVDDrive -ISO $ISO -Link | Out-Null
}
