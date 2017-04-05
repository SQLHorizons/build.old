Function Wait-ForDnsResource 
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true)]
        [string]$VMName,
        [parameter(Mandatory = $true)]
        [string]$DNServer
    )
    $i = 0

    $DnsServerResourceRecord = @{
        ZoneName = $env:USERDNSDOMAIN
        Name = $VMName
        ComputerName = $DNServer
        ErrorAction = "SilentlyContinue"
        }

    while (-not(Get-DnsServerResourceRecord @DnsServerResourceRecord))
    {
        Write-Host $i
        if($i -eq 4){Throw "Failed to find an dns record for $VMName"}
        Start-Sleep -Seconds 300
        $i++
    }
}
