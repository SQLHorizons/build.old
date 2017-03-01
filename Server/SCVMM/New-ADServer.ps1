Function New-ADServer
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true)]
        [string]$VMName,
        [parameter(Mandatory = $true)]
        [string]$Description
    )
    
    if($VMName.Length -le 8)
    {
        switch ($VMName.Split("-")[1].Substring(0,2))
        {
            "DE"
            {
                [string]$ADPath = "OU=Virtual Servers,OU=Dereham,OU=Member Servers,DC=norfolk,DC=police,DC=uk";
                [string]$Tag    = "DE MER3";
                break
            }
            "MA"
            {
                [string]$ADPath = "OU=Virtual Servers,OU=MA,OU=Member Servers,DC=norfolk,DC=police,DC=uk";
                [string]$Tag    = "MA PBX";
                break
            }
            "OC"
            {
                # What MER?
                $SelectValue = @{
                    InputObject = [ordered]@{MER1 = "OCC MER1"; MER2 = "OCC MER2";}
                    PassThru = $true
                    Title = "Select which MER this VM is to be deployed into"
                }

                switch ((Out-GridView @SelectValue).Name)
                {
                    "MER1"
                    {
                        [string]$ADPath = "OU=MER1 Hyper-V,OU=Production Virtual Servers,OU=OCC,OU=Member Servers,DC=norfolk,DC=police,DC=uk";
                        [string]$Tag    = "OCC MER1";
                        break
                    }
                    "MER2"
                    {
                        [string]$ADPath = "OU=MER2 Hyper-V,OU=Production Virtual Servers,OU=OCC,OU=Member Servers,DC=norfolk,DC=police,DC=uk";
                        [string]$Tag    = "OCC MER2";
                        break
                    }
                }
            }
            default {Throw "Failed to find OU for VMHost $VMName"}
        }

        if (Get-ADOrganizationalUnit -Identity $ADPath)
        {
            #New-ADComputer -Name $VMName -SamAccountName $VMName -Description $Description -Path $ADPath -WhatIf
            New-ADComputer -Name $VMName -SamAccountName $VMName -Description $Description -Path $ADPath
            Return $Tag
        }
        else
        {
            Throw "OU don't exist, check the Tag name and that you are running this against OCCloud"
        }
    }
    else
    {
        Throw "Check VM Name format is correct."
    }
}
