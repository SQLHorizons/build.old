Function New-fn_SQLServerBackupDir
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter()]
        [object]$SQLServer = $env:COMPUTERNAME,
        [parameter()]
        [object]$Database  = "msdb"
    )

    Get-SQLPSModule

    $SQLfunctionparameters = @{
        SQLServer   = $SQLServer
        Database    = $Database
        SQLfunction = "fn_SQLServerBackupDir"
        TextHeader  = "CREATE FUNCTION dbo.fn_SQLServerBackupDir() RETURNS NVARCHAR(4000) AS"
        TextBody    = "
    BEGIN 
        DECLARE @path NVARCHAR(4000) 

        EXEC master.dbo.xp_instance_regread 
        N'HKEY_LOCAL_MACHINE', 
        N'Software\Microsoft\MSSQLServer\MSSQLServer',N'BackupDirectory', 
        @path OUTPUT,  
        'no_output' 
        RETURN @path 

    END;"       
    }

    New-SQLfunction @SQLfunctionparameters -Verbose
}
