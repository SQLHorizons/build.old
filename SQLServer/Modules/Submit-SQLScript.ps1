Function Submit-SQLScript
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$ServerInstance,
        [parameter(Mandatory = $true)]
        [string]$Database,
        [parameter(Mandatory = $true)]
        [string]$Queryfile
    )
    
    $SqlCommandText = Get-Content $Queryfile;
    
    $SqlConnection = Get-SQLConnection -Server $ServerInstance -Database $Database;
    Write-Verbose "Creating New Object for SqlCommand file: $($Queryfile)..."
    $SqlCommand = New-Object -TypeName System.Data.SqlClient.SqlCommand($SqlCommandText, $SqlConnection)
    $SqlCommand.CommandTimeout = 300
    
    $SqlConnection.Open()
    Write-Verbose "Executing SQL Command '$($SqlCommand.CommandText)'..."
    $results = $SqlCommand.ExecuteScalar()
    
    if ($SqlConnection.State -eq [Data.ConnectionState]::Open) { $SqlConnection.Close() }
}
