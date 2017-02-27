Function Deploy-Quick2012R2VM
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true)]
        [string]$VMMServer,
        [parameter(Mandatory = $true)]
        [string]$VMName,
        [parameter(Mandatory = $true)]
        [string]$VMHost,
        [parameter(Mandatory = $true)]
        [string]$HardwareProfile,
        [parameter(Mandatory = $true)]
        [string]$Volume,
        [parameter(Mandatory = $true)]
        [string]$Description,
        [parameter(Mandatory = $true)]
        [string]$Tag,
        [string]$SCVMTemplate = "OC Server 2012 R2 Template"
    )

    Try
    {
        $GuiRunOnceCommands = ""
        $DestinationLocation = "C:\ClusterStorage\$Volume\"
        $JobGroupId = [Guid]::NewGuid().ToString()
        $Cluster = "OCCloud1"

        <#
        switch ($Tag)
        {
            "OCC MER1" {[string]$VMHost = $((Get-SCVMHostCluster $Cluster).Nodes.Computername|Where-Object {($_ -split '')[6] -eq 1})|Out-Gridview -PassThru -Title 'Select VM Host';break}
            "OCC MER2" {[string]$VMHost = $((Get-SCVMHostCluster $Cluster).Nodes.Computername|Where-Object {($_ -split '')[6] -eq 2})|Out-Gridview -PassThru -Title 'Select VM Host';break}
            default {Throw "Failed to find VMHost"}
        }
        #>

        ################################################################################################################################

        $NATArguments = @{
            VMMServer = $VMMServer
            JobGroup = $JobGroupId
            MACAddressType = "Dynamic"
            VLanEnabled = $false
            Synthetic = $true
            EnableVMNetworkOptimization = $false
            EnableMACAddressSpoofing = $false
            EnableGuestIPNetworkVirtualizationUpdates = $false
            IPv4AddressType = "Static"
            VMNetwork = Get-SCVMNetwork -VMMServer $VMMServer|Out-Gridview -PassThru -Title 'Select VM Network'
            }

        New-SCVirtualNetworkAdapter @NATArguments

        ################################################################################################################################

        $VMTemplateArguments = @{
            Name = "Temporary Template for Build"
            Template = Get-SCVMTemplate -VMMServer $VMMServer | where {$_.Name -eq $SCVMTemplate}
            HardwareProfile = Get-SCHardwareProfile -VMMServer $VMMServer | where {$_.Name -eq $HardwareProfile}
            JobGroup = $JobGroupId
            ComputerName = $VMName
            TimeZone = 85
            LocalAdministratorCredential = Get-SCRunAsAccount -VMMServer "$VMMServer" -Name "LocalAdmin"
            GuiRunOnceCommands = $GuiRunOnceCommands
            AnswerFile = $null
            OperatingSystem = Get-SCOperatingSystem -VMMServer $VMMServer | where {$_.Name -eq "Windows Server 2012 R2 Standard"}
            }

        $NewVMConfigurationArguments = @{
            Name = $VMName
            VMTemplate = New-SCVMTemplate @VMTemplateArguments
            }
    
        $VirtualMachineConfiguration = New-SCVMConfiguration @NewVMConfigurationArguments

        ################################################################################################################################

        $SetVMConfigurationArguments = @{
            Description = $Description
            VMConfiguration = $VirtualMachineConfiguration
            VMHost = Get-SCVMHost -ComputerName $VMHost
            VMLocation = $DestinationLocation
            PinVMLocation = $true
            Tag = $Tag
            }

        Set-SCVMConfiguration @SetVMConfigurationArguments|Out-Null

        $VMHDConfigurationArguments = @{
            VHDConfiguration = Get-SCVirtualHardDiskConfiguration -VMConfiguration $virtualMachineConfiguration
            PinSourceLocation = $false
            DestinationLocation = $DestinationLocation
            FileName = "$($VMName).vhdx"
            DeploymentOption = "UseNetwork"
            }

        Set-SCVirtualHardDiskConfiguration @VMHDConfigurationArguments|Out-Null
        Update-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration|Out-Null

        ################################################################################################################################

        #Write-Output $virtualMachineConfiguration

        $VirtualMachineArguments = @{
            Name = $VMName
            VMConfiguration = $virtualMachineConfiguration
            BlockDynamicOptimization = $false
            StartVM = $true
            JobGroup = $JobGroupId
            ReturnImmediately = $true
            StartAction = "NeverAutoTurnOnVM"
            StopAction = "SaveVM"
            JobVariable = "JobVariable"
            }

        New-SCVirtualMachine @VirtualMachineArguments

        Return $JobVariable

        ################################################################################################################################
    }
    catch
    {
        Throw $Error[0]
    }
    
}

    $Quick2012R2VM = @{
        VMMServer = ""
        VMName = ""
        VMHost = ""
        HardwareProfile = ""
        Volume = "Volume3"
        Description = "Function: DC, Owner: Server Team, Built By Paul Maxfield, Build Date: $(Get-Date -Format dd/MM/yyyy)"
        Tag = ""
        }

$JobVariable = Deploy-Quick2012R2VM @Quick2012R2VM
