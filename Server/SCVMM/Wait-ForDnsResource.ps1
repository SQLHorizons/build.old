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
        Start-Sleep -Seconds 300
        $i++
    }
}
