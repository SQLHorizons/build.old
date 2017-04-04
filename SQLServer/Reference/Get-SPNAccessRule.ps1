# Function returns the Service-Principal-Name Access Rule, but this cannot be used is setting the ACL on the service account object
# For reference only

function Get-SPNAccessRule
{
    $root     = [ADSI]"LDAP://RootDSE"
    $schema   = $root.psbase.properties["schemaNamingContext"][0]
    $spnEntry = [ADSI]"LDAP://CN=Service-Principal-Name,$schema"

    $spnSGuid = New-Object System.Guid @( ,$spnEntry.psbase.Properties["schemaIDGUID"][0])
    $identity = New-Object Security.Principal.NTAccount("NT AUTHORITY\SELF")
    Return New-Object DirectoryServices.ActiveDirectoryAccessRule($identity, "ReadProperty,WriteProperty", "Allow", $spnSGuid, "None")
}
