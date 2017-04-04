Function Get-SPNAccessControlEntry
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Identity,
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [pscredential]$Credential
    )

    $GetADUserparameters = @{
        Identity = $Identity
        Credential = $Credential
    }  
    $ADObject = Get-ADUser @GetADUserparameters

    $GetADObject = @{
        Filter = {Name -eq "Service-Principal-Name"}
        SearchBase = (Get-ADRootDSE).schemaNamingContext
        Properties = "Name", "schemaIDGuid"
        }
    $objectGuid = New-Object System.Guid @( ,(Get-ADObject @GetADObject).schemaIDGuid)

    $acl = Get-Acl -Path "AD:\$($ADObject.DistinguishedName)"
    Return $acl.Access | Where-Object {$_.ObjectType -eq $objectGuid}
}

    $SPNAccessControlEntry = @{
        Identity = "SA-DBOC59-SQLServer"
        Credential = Get-Credential
    }

    Get-SPNAccessControlEntry @SPNAccessControlEntry
