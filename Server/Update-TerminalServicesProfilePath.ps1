Remove-Variable TSProperties
[Array]$TSProperties = $null
$count = 0
    
$ADUsers = Get-ADUser -Filter *

$count = 0
ForEach($UserObject in $ADUsers | Select-Object -First 10000)
{
    $ADSIObject = [ADSI]"LDAP://$($UserObject.DistinguishedName)"
    Try
    {
        $TerminalServicesProfilePath = $ADSIObject.PSBase.InvokeGet("TerminalServicesProfilePath")
        if($TerminalServicesProfilePath -like "\\IS-OCC01\TSProfiles$\*")
        {
            Write-Host "Updating TS Profile for $($ADSIObject.displayName[0]), current path '$TerminalServicesProfilePath'." -ForegroundColor Yellow
            $NewTerminalServicesProfilePath = $TerminalServicesProfilePath -ireplace [regex]::Escape("\\IS-OCC01\TSProfiles$\"), "\\profiles\TS$\"
            Write-Host "New TS profile path '$NewTerminalServicesProfilePath' is active $(Test-Path $NewTerminalServicesProfilePath). `n" -ForegroundColor Yellow

            $ADSIObject.PSBase.InvokeSet("TerminalServicesProfilePath",$NewTerminalServicesProfilePath)
            $ADSIObject.setinfo()

            $count++
        }
    }
    Catch
    {
        if($Error[0].Exception.InnerException -eq "The directory property cannot be found in the cache."){Continue}
    }
}
    
Write-Host "$count User TS Profile paths updated." -ForegroundColor Green 
