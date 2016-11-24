# Install WMF 5.0
$PSVersionTable.PSVersion

$WMFmsu = "\\library\PoSh\WMF5.0\Win8.1AndW2K12R2-KB3134758-x64.msu"

$MSUArguments = @(
    "/install $WMFmsu"
    "/quiet"
    "/warnrestart"
)
Start-Process "wusa" -ArgumentList $MSUArguments -Wait -NoNewWindow

<#
    foreach ($num in 1,2,3,4,5)
    {
        Clear-Disk -Number $num -RemoveData –RemoveOEM -Confirm:$false -ErrorAction SilentlyContinue
    }
    cls
#>