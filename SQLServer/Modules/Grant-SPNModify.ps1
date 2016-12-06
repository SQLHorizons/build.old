Function Grant-SPNModify
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ADSI]$TargetObject,
        [parameter(Mandatory = $true)]
        [pscredential]$Credential
    )
    
    [Security.Principal.IdentityReference]$Identity = [security.principal.ntaccount]"NT AUTHORITY\SELF"
    
    $adRight = [DirectoryServices.ActiveDirectoryRights]"readproperty,writeproperty"
    
    $rootDSE = [ADSI]"LDAP://RootDSE"
    $schemaDN = $rootDSE.psbase.properties["schemaNamingContext"][0]
    $spnEntry = [ADSI]"LDAP://CN=Service-Principal-Name,$schemaDN"
    $spnSecGuid = New-Object -TypeName System.Guid @( ,$spnEntry.psbase.Properties["schemaIDGUID"][0])
    
    $spnAce = New-Object -TypeName DirectoryServices.ActiveDirectoryAccessRule($identity, $adRight, "Allow", $spnSecGuid, "None")
    
    $TargetObject.psbase.ObjectSecurity.AddAccessRule($spnAce)
    $TargetObject.psbase.CommitChanges()
}
