Function Install-TSMBAClient
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$TSMSoftware,
        [parameter(Mandatory = $true)]
        [string]$InstallDir,
        [parameter(Mandatory = $true)]
        [string]$password
    )
     
    $TSMSWfiles = "$($TSMSoftware)\TSM_BA_Client_7.1.6.2_WinX64"
    $Optionfiles = "$($TSMSoftware)\Config Files\BA SQL Client"
    $TEMPfiles = "$($env:TEMP)\TSM_BA_Client"
    
    $RegistryPath = "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $TSMFileHash = Get-FileHash -Path "$($TSMSWfiles)\IBM Tivoli Storage Manager Client.msi" -Algorithm MD5
    
    Copy-Folder -Source $TSMSWfiles -Destination $TEMPfiles
    
    Write-Host "`
The server team will need to create node names in client option set 'CS_Windows_SQL'`
and allocate to a schedule, see that node name $env:COMPUTERNAME is created before proceeding!`
"
    if (Test-Path $TEMPfiles)
    {
        Push-Location $TEMPfiles
        if (Get-FileHash -Path $TEMPfiles\"IBM Tivoli Storage Manager Client.msi" -Algorithm MD5 | Where-Object { $_.Hash -eq $TSMFileHash.Hash })
        {
            $vcredist_x86parameters = @{
                ExecutableName = "Microsoft Visual C++ 2012 Redistributable (x86) *"
                ExecutablePath = ".\ISSetupPrerequisites\{BF2F04CD-3D1F-444e-8960-D08EBD285C3F}\vcredist_x86.exe"
                Verbose = $true
            }
            Install-Executable @vcredist_x86parameters
            Start-Sleep -s 5
            $vcredist_x64parameters = @{
                ExecutableName = "Microsoft Visual C++ 2012 Redistributable (x64) *"
                ExecutablePath = ".\ISSetupPrerequisites\{3A3AF437-A9CD-472f-9BC9-8EEDD7505A02}\vcredist_x64.exe"
                Verbose = $true
            }
            Install-Executable @vcredist_x64parameters
            Start-Sleep -s 5
            
            
            if (!((Get-ItemProperty $RegistryPath).Where{ $_.DisplayName -like "IBM Tivoli Storage Manager Client" }))
            {
                if ((Get-Process).Where{ $_.ProcessName -eq "msiexec" })
                { Wait-Process -Id (Get-Process).Where{ $_.ProcessName -eq "msiexec" }.Id }
                Write-Verbose "Installing IBM Tivoli Storage Manager Client..."
                
                $msiArgumentList = "/i `"IBM Tivoli Storage Manager Client.msi`" RebootYesNo=No "
                $msiArgumentList += "REBOOT=Suppress ALLUSERS=1 INSTALLDIR=T:\Data_X\tivoli\tsm "
                $msiArgumentList += "ADDLOCAL=BackupArchiveGUI,BackupArchiveWeb,Api64Runtime,AdministrativeCmd "
                $msiArgumentList += "TRANSFORMS=1033.mst /qn /l*v $env:TEMP\$env:COMPUTERNAME-tivolitsm.log"
                Start-Process -FilePath msiexec.exe -ArgumentList $msiArgumentList -Wait -WindowStyle Hidden
                
                foreach ($Optionfile in Get-ChildItem $Optionfiles -File)
                {
                    if (!(Test-Path "$InstallDir\$Optionfile"))
                    {
                        Write-Verbose "Copying file $Optionfiles\$Optionfile to $InstallDir\$Optionfile"
                        Copy-Item -Path "$Optionfiles\$Optionfile" -Destination "$InstallDir\$Optionfile"
                    }
                }

                Install-TSMServices -InstallDir $InstallDir -password $password

                if (Test-Path $TEMPfiles) { Remove-Item $TEMPfiles -Recurse -Force -ErrorAction SilentlyContinue}
            }
        }
    Pop-Location
    }
}
