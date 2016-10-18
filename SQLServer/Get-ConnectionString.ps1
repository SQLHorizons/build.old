Function Get-ConnectionString
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true)]
        [object]$Server,
        [parameter(Mandatory = $true)]
        [object]$Database,
        [object]$IntegratedSecurity = $true
    )

    Return "Server=$($Server);Database=$($Database);Integrated Security=$($IntegratedSecurity);"
}
