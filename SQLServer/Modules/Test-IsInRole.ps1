Function Test-IsInRole
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Role,
        [parameter(Mandatory = $true)]
        [pscredential]$Credential
    )

    Get-ActiveDirectoryModle
    
    $ADfilter = "Name -eq `"$($Credential.UserName.Split("\")[1])`""
    $UserPrincipalName = (Get-ADUser -Filter $ADfilter).UserPrincipalName
    if ($UserPrincipalName)
    {
        $WindowsPrincipal = New-Object -TypeName System.Security.Principal.WindowsPrincipal($UserPrincipalName)
        if ($WindowsPrincipal.IsInRole($Role))
        {
            Write-Verbose "Currently running as a $($Role)"
            Return $true
        }
        else { Write-Verbose "Currently NOT running as a $($Role)" }
    }
    else { Write-Verbose "$($Credential.UserName) is NOT a valid user Account" }
    Return $false
}

<#
$Role = "Domain Admins"
$Credential = Get-Credential -Credential "NORFOLK\OpsAdmin26"

Test-IsInRole -Role $Role -Credential $Credential -Verbose
#>