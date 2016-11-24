# Add Administrator Group Member

$ASUparameters = @{
    DomainName   = "NORFOLK"
    UserName     = "SQLSpotlightServer"
    ComputerName = $env:COMPUTERNAME
    Verbose      = $true
}

Add-GroupMember @ASUparameters;
Add-SQLLogin    @ASUparameters;
