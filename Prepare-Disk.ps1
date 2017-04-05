Function Prepare-Disk
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [uint16]$Number

    )

    $Disk = Get-Disk -Number $Number

    if ($Disk.IsOffline -eq $true)
    {
        Write-Verbose "Setting      disk number '$($Disk.Number)' Online"
        $Disk | Set-Disk -IsOffline $false
    }
        
    if ($Disk.IsReadOnly -eq $true)
    {
        Write-Verbose "Setting      disk number '$($Disk.Number)' to not ReadOnly"
        $Disk | Set-Disk -IsReadOnly $false
    }

    Write-Verbose -Message "Checking     existing disk partition style..."
    if (($Disk.PartitionStyle -ne "GPT") -and ($Disk.PartitionStyle -ne "RAW"))
    {
        Throw "Disk         '$($Disk.Number)' is already initialised with '$($Disk.PartitionStyle)'"
    }
    else
    {
        if ($Disk.PartitionStyle -eq "RAW")
        {
            Write-Verbose -Message "Initializing disk number '$($Disk.Number)'."
            $Disk | Initialize-Disk -PartitionStyle "GPT" -PassThru|Out-Null
        }
        else
        {
            Write-Verbose -Message "Disk         number '$($Disk.Number)' is already configured for 'GPT'"
        }
    }

    Return $Disk
}
