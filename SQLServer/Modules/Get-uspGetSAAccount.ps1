Function Get-uspGetSAAccount
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true)]
        [object]$SqlConnection,
        [parameter(Mandatory = $true)]
        [string]$SACredential 
    )

    [string]$StoredProcedure  = "[SQLOPs].[Get-SAAccount]"
    [string]$pramNS           = "Data.SqlClient.SqlParameter"

    Write-Verbose "Creating New Object for SqlCommand: $($StoredProcedure)..."
    $SqlCommand = New-Object -TypeName System.Data.SqlClient.SqlCommand($StoredProcedure,$SqlConnection)

    $SqlCommand.CommandType = [System.Data.CommandType]::StoredProcedure

    Write-Verbose "Creating Parameters for SqlCommand..."
    $SqlCommand.Parameters.Add((New-Object $pramNS('@SA_Account',   [Data.SQLDBType]::VarChar, 20)))|Out-Null

    Write-Verbose "Setting Parameters for SqlCommand..."
    $SqlCommand.Parameters[0].Value = ($SACredential.split('\')[-1]).Replace("`"","")

    Write-Verbose "Passing back SqlCommand object..."
    Return $SqlCommand
}
