$Server = "s1"

$parameters = @{
    DNSServer = "A-DNS-Server-02"
    ClientRecord = $Server
}

Get-DnsClientRecord @parameters
