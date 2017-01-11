    $Credential = Get-Credential

    $GetADUserparameters = @{
        Identity = "SA-DBOC99-SQLServer"
        Credential = $Credential
    }
        
    $Account = Get-ADUser @GetADUserparameters

    $do = {
    Param(
    $ADObject
    )
    
    $rootDSE = [ADSI]"LDAP://RootDSE"
    $rootDSE
    $schemaDN = $rootDSE.psbase.properties["schemaNamingContext"][0]
    $spnEntry = [ADSI]"LDAP://CN=Service-Principal-Name,$schemaDN"
    $spnEntry 
    $spnSecGuid = New-Object -TypeName System.Guid @( ,$spnEntry.psbase.Properties["schemaIDGUID"][0])

    [Security.Principal.IdentityReference]$Identity = [security.principal.ntaccount]"NT AUTHORITY\SELF"
    
    $adRight = [DirectoryServices.ActiveDirectoryRights]"readproperty,writeproperty"
    
    $spnAce = New-Object -TypeName DirectoryServices.ActiveDirectoryAccessRule($identity, $adRight, "Allow", $spnSecGuid, "None")

    $TargetObject = [ADSI]"LDAP://$($ADObject.DistinguishedName)"
    $TargetObject.psbase.ObjectSecurity.AddAccessRule($spnAce)
    $TargetObject.psbase.CommitChanges()
    }

    $InvokeCmdparam = @{
        ScriptBlock = $do
        ArgumentList = $Account
        Credential = $Credential
        ComputerName = $env:COMPUTERNAME
    }

    Invoke-Command @InvokeCmdparam

    &$do $Account
    
