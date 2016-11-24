Function Get-uspSetSAAccount
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true)]
        [object]$SqlConnection,
        [parameter(Mandatory = $true)]
        [string]$SQLServer,
        [parameter(Mandatory = $true)]
        [pscredential]$SACredential 
    )

    [string]$StoredProcedure  = "[SQLOPs].[Set-SAAccount]"
    [string]$pramNS           = "Data.SqlClient.SqlParameter"

    Write-Verbose "Creating New Object for SqlCommand: $($StoredProcedure)..."
    $SqlCommand = New-Object -TypeName System.Data.SqlClient.SqlCommand($StoredProcedure,$SqlConnection)

    $SqlCommand.CommandType = [System.Data.CommandType]::StoredProcedure

    Write-Verbose "Creating Parameters for SqlCommand..."
    $SqlCommand.Parameters.Add((New-Object $pramNS('@SQLSrv',       [Data.SQLDBType]::VarChar, 20)))|Out-Null
    $SqlCommand.Parameters.Add((New-Object $pramNS('@SA_Account',   [Data.SQLDBType]::VarChar, 20)))|Out-Null
    $SqlCommand.Parameters.Add((New-Object $pramNS('@SA_AccountPWD',[Data.SQLDBType]::VarChar, 50)))|Out-Null

    Write-Verbose "Setting Parameters for SqlCommand..."
    $SqlCommand.Parameters[0].Value = $SQLServer
    $SqlCommand.Parameters[1].Value = ($($SACredential.username).split('\')[-1]).Replace("`"","")
    $SqlCommand.Parameters[2].Value = $SACredential.GetNetworkCredential().password

    Write-Verbose "Passing back SqlCommand object..."
    Return $SqlCommand
}
