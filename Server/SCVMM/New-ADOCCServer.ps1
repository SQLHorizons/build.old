Function New-ADOCCServer
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true)]
        [string]$VMName,
        [parameter(Mandatory = $true)]
        [string]$Description,
        [parameter(Mandatory = $true)]
        [string]$Tag
    )

    $ADPath = "OU=$(($Tag -split ' ')[1]) Hyper-V,OU=Production Virtual Servers,OU=OCC,OU=Member Servers,DC=norfolk,DC=scouts,DC=uk"

    if (Get-ADOrganizationalUnit -Identity $ADPath)
    {
        New-ADComputer -Name $VMName -SamAccountName $VMName -Description $Description -Path $ADPath
    }
    else
    {
        Throw "OU don't exist, check the Tag name and that you are running this against OCCloud"
    }
}

$VMName = "AS-OC182"
$Description = "Function: IIS, Owner: Application Team, Built By PDM, Build Date: 22/02/2017"
$Tag = "OCC MER1"

New-ADOCCServer -VMName $VMName -Description $Description -Tag $Tag
