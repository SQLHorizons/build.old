$OUPath = "OU=SQL,OU=MER1 Hyper-V,OU=Production Virtual Servers,OU=OCC,OU=Member Servers,DC=norfolk,DC=police,DC=uk"

If ((Get-Content "$($env:windir)\system32\Drivers\etc\hosts") -notcontains "10.34.81.2 is-oc02.norfolk.police.uk")   
{
    Add-Content -Encoding UTF8  "$($env:windir)\system32\Drivers\etc\hosts" "10.34.81.2 is-oc02.norfolk.police.uk"
}

$AddComputer = @{
    DomainName = "NORFOLK"
    Server = "IS-OC02"
    OUPath = $OUPath
    Credential = $(Get-Credential -UserName "NORFOLK\Administrator" -Message "Enter Password")
    Restart = $true
    }

Add-Computer @AddComputer
