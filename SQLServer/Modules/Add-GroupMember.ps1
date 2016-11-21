Function Add-GroupMember
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true)]
        [string]$DomainName,
        [parameter(Mandatory = $true)]
        [string]$UserName,
        [parameter(Mandatory = $true)]
        [string]$ComputerName
    )
    
    $AdminGroup  = [ADSI]"WinNT://$ComputerName/Administrators,group"
    $MemberNames = @(foreach ($Member in $AdminGroup.psbase.Invoke("Members"))
        {
            $Member.GetType().InvokeMember("Name", 'GetProperty', $null, $Member, $null)
        }
    )
    
    if (!$MemberNames.Contains($UserName))
    {
        $AdminGroup.Add("WinNT://$DomainName/$UserName,user")
    }
}
