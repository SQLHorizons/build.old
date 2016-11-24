# Setup of database mail

$mailParameters = @{
    account_name    = "DBA Alerts";
    sqlServer       = $env:COMPUTERNAME;
    email_address   = "dbaalerts@sqlhorizons.com";
    mailserver_name = "cas.sqlhorizons.com";
    profile_name    = "DBA Alerts";
    display_name    = $env:COMPUTERNAME;
    replyto_address = "dbaalerts@sqlhorizons.com";
    description     = "Mail account to send alerts for the DBAs";
    mailserver_type = "SMTP";
    port            = 25
}

Set-xSQLServerDatabaseMail @mailParameters -Verbose
