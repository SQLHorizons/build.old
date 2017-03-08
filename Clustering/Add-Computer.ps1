$OUPath = "OU=SQL,OU=MER1 Hyper-V,OU=Production Virtual Servers,OU=OCC,OU=Member Servers,DC=norfolk,DC=police,DC=uk"

$AddComputer = @{
    DomainName = "NORFOLK"
    Server = "IS-OC02"
    OUPath = $OUPath
    Credential = $(Get-Credential -UserName "NORFOLK\Administrator" -Message "Enter Password")
    Restart = $true
    }

Add-Computer @AddComputer
