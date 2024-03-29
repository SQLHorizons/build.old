﻿Function Set-SAAccount
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [pscredential]$SACredential,
        [parameter(Mandatory = $true)]
        [string]$SQLServer,
        [parameter(Mandatory = $true)]
        [string]$DatabaseServer,
        [parameter(Mandatory = $true)]
        [string]$Database         
    )

    $SqlConnection = Get-SQLConnection -Server $DatabaseServer -Database $Database;
    $SqlCommand    = Get-uspSetSAAccount -SqlConnection $SqlConnection -SQLServer $SQLServer -SACredential $SACredential;

    $SqlConnection.Open()
    Write-Verbose "Executing SQL Command '$($SqlCommand.CommandText)'..."
    $SqlCommand.ExecuteScalar()
    if ($SqlConnection.State -eq [Data.ConnectionState]::Open){$SqlConnection.Close()}
}
