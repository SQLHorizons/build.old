Function Test-ServiceAccount
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [pscredential]$SACredential
    ) 
    
    $username = $SACredential.username
    $password = $SACredential.GetNetworkCredential().password

    $domain   = "LDAP://" + ([ADSI]"").distinguishedName
    $DirEntry = New-Object -TypeName System.DirectoryServices.DirectoryEntry($domain,$UserName,$Password)

    if (!($DirEntry.name))
    {
        Throw "Authentication failed with domain - please verify your username and password."
    }
    else
    {
        Write-Verbose "Successfully authenticated with domain '$($DirEntry.name)'..."
        $SACredential
    }
}