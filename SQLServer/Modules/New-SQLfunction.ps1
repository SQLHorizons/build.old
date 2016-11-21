function New-SQLfunction
{
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object]$SQLServer,
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object]$Database,
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$SQLfunction,
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$TextHeader,
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$TextBody
    )

    Get-SQLPSModule

    try
    {
        $srvobj = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Server($SQLServer)
        $dbsobj = $srvobj.Databases.Item($Database)

        if(!$dbsobj.UserDefinedFunctions.Item($SQLfunction))
        {
            Write-Verbose "Creating user defined function $($SQLfunction) on database $($Database)"
            $udf = New-Object -TypeName Microsoft.SqlServer.Management.SMO.UserDefinedFunction($dbsobj, $SQLfunction)
            $udf.TextHeader = $TextHeader
            $udf.TextBody   = $TextBody
            $udf.Create()
        }
    }
    catch
    {
        $message = $_.Exception.Message
        Throw "New-SQLfunctions failed with the following error: '$($message)'"
    }
}
