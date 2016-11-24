﻿Function Get-SAAccount
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$SACredential,
        [parameter(Mandatory = $true)]
        [string]$DatabaseServer,
        [parameter(Mandatory = $true)]
        [string]$Database
    )
    
    $SqlConnection = Get-SQLConnection -Server $DatabaseServer -Database $Database;
    $SqlCommand = Get-uspGetSAAccount -SqlConnection $SqlConnection -SACredential $SACredential;
    
    $SqlConnection.Open()
    Write-Verbose "Executing SQL Command '$($SqlCommand.CommandText)'..."
    $SAPassword = $SqlCommand.ExecuteScalar()
    if ($SqlConnection.State -eq [Data.ConnectionState]::Open) { $SqlConnection.Close() }
    Return $SAPassword
}
