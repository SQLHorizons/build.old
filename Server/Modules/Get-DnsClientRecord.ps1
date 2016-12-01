Function Get-DnsClientRecord
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object]$DNSServer,
        [parameter(Mandatory = $true)]
        [object]$ClientRecord
    )

    if (!(Get-Module DnsServer))
    {
        throw "The DnsServer Module is required."
    }
    else
    {
        $results = foreach ($Server in $ClientRecord)
        {
            $HostRecord = Get-DnsServerResourceRecord -ComputerName $DNSServer -ZoneName "norfolk.police.uk" -Name $Server -ErrorAction SilentlyContinue
            $IPv4Address = $HostRecord.RecordData.IPv4Address.IPAddressToString
            $AddrArpa = "$($IPv4Address.Split(".")[-1]).$($IPv4Address.Split(".")[-2]).$($IPv4Address.Split(".")[-3])"
            $PTRrecord = Get-DnsServerResourceRecord -ComputerName $DNSServer -ZoneName "10.in-addr.arpa" -Name $AddrArpa -ErrorAction SilentlyContinue
            
            $HostRecord
            $PTRrecord
        }
        
        Return $results
    }
}
