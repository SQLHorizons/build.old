﻿function Set-xSQLServerDatabaseMail
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]$account_name,
        [parameter(Mandatory = $true)]
        [System.String]$sqlServer,
        [parameter(Mandatory = $true)]
        [System.String]$email_address,
        [parameter(Mandatory = $true)]
        [System.String]$mailserver_name,
        [parameter(Mandatory = $true)]
        [System.String]$profile_name,
        [System.String]$display_name = $sqlServer,
        [System.String]$replyto_address = $email_address,
        [System.String]$description = "Mail account to send alerts for the DBAs",
        [System.String]$mailserver_type = "SMTP",
        [System.UInt16]$port = 25
    )
    
    Get-SQLPSModule
    
    if ($sqlServer)
    {
        Write-Verbose "Load the SMO assembly and create the server object, connecting to server '$($sqlServer)'"
        $null = [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')
        $server = New-Object Microsoft.SqlServer.Management.SMO.Server ($sqlServer)
    }
    
    if ($server)
    {
        Write-Verbose "Configure the SQL Server to enable Database Mail."
        ##Named Pipes had to be enabled, Why??
        if ($server.Configuration.DatabaseMailEnabled.ConfigValue -ne 1)
        {
            $server.Configuration.DatabaseMailEnabled.ConfigValue = 1
            $server.Configuration.Alter()
            ##Test
            $dbMailXPs = $server.Configuration.DatabaseMailEnabled.ConfigValue
            Write-Verbose "Database Mail XPs is '$($dbMailXPs)'"
        }
        else { $dbMailXPs = 1 }
        
        if ($dbMailXPs -eq 1)
        {
            Write-Verbose "Alter mail system parameters if desired, this is an optional step."
            $dBmail = $server.Mail
            $dBmail.ConfigurationValues.Item('LoggingLevel').Value = 1
            $dBmail.ConfigurationValues.Item('LoggingLevel').Alter()
            #Test
            $LoggingLevel = $dBmail.ConfigurationValues.Item('LoggingLevel').Value
            Write-Verbose "Database Mail Logging Level is '$($LoggingLevel)'"
            
            Write-Verbose "Create the mail account '$($account_name)'"
            if (!($dBmail.Accounts | Where-Object { $_.Name -eq $account_name }))
            {
                $account = New-Object Microsoft.SqlServer.Management.SMO.Mail.MailAccount($dBmail, $account_name) -ErrorAction SilentlyContinue
                $account.Description = $description
                $account.DisplayName = $sqlServer
                $account.EmailAddress = $email_address
                $account.ReplyToAddress = $replyto_address
                $account.Create()
                
                $account.MailServers.Item($sqlServer).Rename($mailserver_name)
                $account.Alter()
            }
            else { Write-Verbose "DB mail account '$($account_name)' already esists" }
            
            Write-Verbose "Create a public default profile '$($profile_name)'"
            if (!($dBmail.Profiles | Where-Object { $_.Name -eq $profile_name }))
            {
                $profile = New-Object Microsoft.SqlServer.Management.SMO.Mail.MailProfile($dBmail, $profile_name)
                $profile.Description = $description
                $profile.Create()
                
                $profile.AddAccount($account_name, 0)
                $profile.AddPrincipal('public', 1)
                $profile.Alter()
            }
            else { Write-Verbose "DB mail profile '$($profile_name)' already esists" }
            
            Write-Verbose "Configure the SQL Agent to use dbMail."
            if ($server.JobServer.AgentMailType -ne 'DatabaseMail' -or $server.JobServer.DatabaseMailProfile -ne $profile_name)
            {
                $server.JobServer.AgentMailType = 'DatabaseMail'
                $server.JobServer.DatabaseMailProfile = $profile_name
                $server.JobServer.Alter()
            }
            
        }
    }
}
