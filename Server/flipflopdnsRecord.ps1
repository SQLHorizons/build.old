function Switch-DNSResourceRecord
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $false)]
        [System.Net.IPAddress]$ipAddr1 = "10.34.82.49",
        [parameter(Mandatory = $false)]
        [System.Net.IPAddress]$ipAddr2 = "10.129.81.35",
        [parameter(Mandatory = $false)]
        [string]$dnsServer             = "IS-OC02"
    )

    $CommonParameters = @{
        ComputerName = $dnsServer
        ZoneName     = $($env:USERDNSDOMAIN.ToLower())
        Verbose      = $true
        }

    $oldhostRecord = Get-DnsServerResourceRecord @CommonParameters -Name mitel-db
    $newhostRecord = $oldhostRecord.PSObject.Copy()

    switch ($oldhostRecord.RecordData.IPv4Address)
    {
        $ipAddr1 {$newhostRecord.RecordData.IPv4Address = $ipAddr2}
        $ipAddr2 {$newhostRecord.RecordData.IPv4Address = $ipAddr1}
    }
    Set-DnsServerResourceRecord @CommonParameters -NewInputObject $newhostRecord -OldInputObject $oldhostRecord
    Return $newhostRecord.RecordData.IPv4Address
}

Switch-DNSResourceRecord -Verbose
