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
        [string]$Tag
    )

    Try
    {
        $GuiRunOnceCommands = "C:\Windows\ccmsetup\ccmsetup.exe SMSSITECODE=CM1 FSP=MS-OC33.norfolk.police.uk"
        $DestinationLocation = "C:\ClusterStorage\$Volume\"
        $JobGroupId = [Guid]::NewGuid().ToString()

        ################################################################################################################################

        $SCHardwareProfile = Get-SCHardwareProfile -VMMServer $VMMServer | where {$_.Name -eq $HardwareProfile}
        
        $NATArguments = @{
            VirtualNetworkAdapter = Get-SCVirtualNetworkAdapter -HardwareProfile $SCHardwareProfile
            VMNetwork = Get-SCVMNetwork -VMMServer $VMMServer|Out-Gridview -PassThru -Title 'Select VM Network'
            }

        Set-SCVirtualNetworkAdapter @NATArguments

        [string]$SCVMTemplate = (Get-SCVMTemplate -VMMServer $VMMServer |
            Where-Object {$_.Name -like "*Server 2012 R2 Template*"}).Name |
                Out-Gridview -PassThru -Title "Select Template"

        $VMTemplateArguments = @{
            Name = "Temporary Template $([Guid]::NewGuid().ToString())" 
            Template = Get-SCVMTemplate -VMMServer $VMMServer | Where-Object {$_.Name -eq $SCVMTemplate}
            HardwareProfile = $SCHardwareProfile
            JobGroup = $JobGroupId
            ComputerName = $VMName
            TimeZone = 85
            LocalAdministratorCredential = Get-SCRunAsAccount -VMMServer "$VMMServer" -Name "LocalAdmin"
            GuiRunOnceCommands = $GuiRunOnceCommands
            AnswerFile = $null
            OperatingSystem = Get-SCOperatingSystem -VMMServer $VMMServer | Where-Object {$_.Name -eq "Windows Server 2012 R2 Standard"}
            } 

        $NewVMConfigurationArguments = @{
            Name = $VMName
            VMTemplate = New-SCVMTemplate @VMTemplateArguments
            }
    
        $VirtualMachineConfiguration = New-SCVMConfiguration @NewVMConfigurationArguments

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
