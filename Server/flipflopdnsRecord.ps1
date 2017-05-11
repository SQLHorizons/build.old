[System.Net.IPAddress]$dboc56 = "10.34.82.49"
[System.Net.IPAddress]$dbde56 = "10.129.81.35"

$oldhostRecord = Get-DnsServerResourceRecord -ComputerName IS-OC02 -ZoneName norfolk.police.uk -Name mitel-db
$newhostRecord = $oldhostRecord.PSObject.Copy()
switch ($oldhostRecord.RecordData.IPv4Address)
{
    $dboc56 {$newhostRecord.RecordData.IPv4Address = $dbde56}
    $dbde56 {$newhostRecord.RecordData.IPv4Address = $dboc56}
}
Set-DnsServerResourceRecord -NewInputObject $newhostRecord -OldInputObject $oldhostRecord -ZoneName norfolk.police.uk -ComputerName IS-OC02
$newhostRecord.RecordData.IPv4Address
