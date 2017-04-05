 Function Get-RDPSession
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Server
    )
    
    $mstsc = "$env:windir\system32\mstsc.exe"
    $mstscArguments = @(
        "/v:$Server"
        "/admin"
    )
    if(Test-Connection $Server -Count 1 -Quiet)
    {
        Start-Process $mstsc -ArgumentList $mstscArguments
    }
}
