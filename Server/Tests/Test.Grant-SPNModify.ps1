    $do = {

    $root     = [ADSI]"LDAP://RootDSE"
    $schema   = $root.psbase.properties["schemaNamingContext"][0]
    $spnEntry = [ADSI]"LDAP://CN=Service-Principal-Name,$schema"

    $spnSGuid = New-Object -TypeName System.Guid @( ,$spnEntry.psbase.Properties["schemaIDGUID"][0])
    [Security.Principal.IdentityReference]$identity = [security.principal.ntaccount]"NT AUTHORITY\SELF"
    $adRight  = [DirectoryServices.ActiveDirectoryRights]"readproperty,writeproperty"

    $spnAce   = New-Object -TypeName DirectoryServices.ActiveDirectoryAccessRule($identity, $adRight, "Allow", $spnSGuid, "None")
    $spnAce

    }

    Enable-WSManCredSSP -Role "Client" -DelegateComputer $env:COMPUTERNAME -Force | Out-Null
    Enable-WSManCredSSP -Role Server –Force | Out-Null

    $PSSessionparam = @{
        ComputerName = $env:COMPUTERNAME
        Authentication = "Credssp"
        Credential = $Credential
    }
    $PSSession = New-PSSession @PSSessionparam

    #Get-PSSession|Disconnect-PSSession|Remove-PSSession
    #Import-Module ActiveDirectory -PSSession $PSSession -Force| Out-Null

    $InvokeCmdparam = @{
        ScriptBlock = $do
        ArgumentList = $Account
        Session = $PSSession
    }
    Invoke-Command @InvokeCmdparam

    &$do
    
