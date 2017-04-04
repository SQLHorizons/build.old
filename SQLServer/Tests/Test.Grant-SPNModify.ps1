    $do = {
        Param(
        [object]$ADObject
        )

        $root     = [ADSI]"LDAP://RootDSE"
        $schema   = $root.psbase.properties["schemaNamingContext"][0]
        $spnEntry = [ADSI]"LDAP://CN=Service-Principal-Name,$schema"

        $spnSGuid = New-Object System.Guid @( ,$spnEntry.psbase.Properties["schemaIDGUID"][0])
        $identity = New-Object Security.Principal.NTAccount("NT AUTHORITY\SELF")
        $spnAce   = New-Object DirectoryServices.ActiveDirectoryAccessRule($identity, "ReadProperty,WriteProperty", "Allow", $spnSGuid, "None")
        # $spnAce
        $TargetObject = [ADSI]"LDAP://$($ADObject.DistinguishedName)"
        $TargetObject.psbase.ObjectSecurity.AddAccessRule($spnAce)
        $TargetObject.psbase.CommitChanges()
        # $TargetObject.psbase.ObjectSecurity.Access | Where-Object {$_.ObjectType -eq $spnSGuid}
    }

    Enable-WSManCredSSP -Role "Client" -DelegateComputer $env:COMPUTERNAME -Force | Out-Null
    Enable-WSManCredSSP -Role Server –Force | Out-Null

    $PSSessionparam = @{
        ComputerName = $env:COMPUTERNAME
        Authentication = "Credssp"
        Credential = $Credential
    }
    $PSSession = New-PSSession @PSSessionparam

    $InvokeCmdparam = @{
        ScriptBlock = $do
        ArgumentList = $Account
        Session = $PSSession
    }
    Invoke-Command @InvokeCmdparam

    $PSSession | Disconnect-PSSession | Remove-PSSession
