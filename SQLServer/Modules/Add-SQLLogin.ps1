Function Add-SQLLogin
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true)]
        [string]$DomainName,
        [parameter(Mandatory = $true)]
        [string]$UserName,
        [parameter(Mandatory = $true)]
        [string]$ComputerName
    )
    
    Get-SQLPSModule
    
    $SQLServer = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $ComputerName
    $ServerRole = $SQLServer.Roles.Item("sysadmin")
    
    if (-not @($ServerRole.EnumMemberNames()).Contains("$DomainName\$UserName"))
    {
        Write-Verbose "Adding role member $DomainName\$UserName to role $($ServerRole.Name)..."
        
        $WINLogin = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Login -ArgumentList $SQLServer, "$DomainName\$UserName"
        $WINLogin.LoginType = "WindowsUser"
        $WINLogin.Create()
        $ServerRole.AddMember("$DomainName\$UserName")
        $ServerRole.Alter()
    }
    else
    {
        Write-Verbose "Role member $DomainName\$UserName already exists in $($ServerRole.Name)..."
    }
}
