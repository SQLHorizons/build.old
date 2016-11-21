Function Get-SQLConnection
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

    $connectionString = "Server=$($Server);Database=$($Database);Integrated Security=$($IntegratedSecurity);"
    Return New-Object -TypeName System.Data.SqlClient.SqlConnection($connectionString);
}
