$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:resourceHelperModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'DscResource.Common'
Import-Module -Name (Join-Path -Path $script:resourceHelperModulePath -ChildPath 'DscResource.Common.psm1')

$script:localizedData = Get-LocalizedData -ResourceName 'ITG_xVMComPort'

<#
.SYNOPSIS
    Gets ITG_xVMComPort resource current state.

.PARAMETER Id
    Specifies an unique identifier for the serial port (unused).

.PARAMETER VMName
    Specifies the name of the VM to which serial port will be connected.

.PARAMETER Number
    Specifies a number of serial port.
#>
Function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    Param (
        [Parameter(Mandatory = $true)]
        [String] $Id,

        [Parameter(Mandatory = $true)]
        [String] $VMName,

        [Parameter(Mandatory = $true)]
        [Int16] $Number
    )

    $configuration = @{
        VMName = $VMName
        Number = $Number
    }
    $arguments = @{
        VMName = $VMName
        Number = $Number
    }

    Write-Verbose -Message $localizedData.GetVMComPort
    $serialPort = Get-VMComPort @arguments -ErrorAction SilentlyContinue

    if ( $serialPort )
    {
        Write-Verbose -Message $localizedData.FoundVMComPort
        $configuration.Add( 'Path', $serialPort.Path )
        $configuration.Add( 'Ensure', 'Present' )
    }
    else
    {
        Write-Verbose -Message $localizedData.NoVMComPortFound
        $configuration.Add( 'Ensure', 'Absent' )
    }

    return $configuration
}

<#
.SYNOPSIS
    Sets ITG_xVMComPort resource state.

.PARAMETER Id
    Specifies an unique identifier for the serial port (unused).

.PARAMETER VMName
    Specifies the name of the VM to which serial port will be connected.

.PARAMETER Number
    Specifies a number of serial port.

.PARAMETER Path
    Specifies a named pipe path to which serial port will be connected.

.PARAMETER Ensure
    Specifies if the serial port should be Present or Absent.
#>
Function Set-TargetResource
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String] $Id,

        [Parameter(Mandatory = $true)]
        [String] $VMName,

        [Parameter(Mandatory = $true)]
        [Int16] $Number,

        [Parameter(Mandatory = $true)]
        [String] $Path,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [String] $Ensure = 'Present'
    )

    $arguments = @{
        VMName = $VMName
        Number = $Number
    }

    Write-Verbose -Message $localizedData.GetVMComPort
    $serialPortExists = Get-VMComPort @arguments -ErrorAction SilentlyContinue

    if ( $Ensure -eq 'Present' )
    {
        if ( $serialPortExists )
        {
            if ( $serialPortExists.Path -ne $Path )
            {
                Write-Verbose -Message $localizedData.VMComPortPathIsDifferent
                Set-VMComPort @arguments -Path $Path -ErrorAction Stop -Verbose
            }
            else
            {
                Write-Verbose -Message $localizedData.VMComPortExistsNoActionNeeded
            }
        }
        else
        {
            Write-Verbose -Message $localizedData.VMComPortDoesNotExistShouldAdd
            Write-Error -Message $localizedData.VMComPortCreationDoesNotSupported
        }
    }
    else
    {
        if ( $serialPortExists )
        {
            Write-Verbose -Message $localizedData.VMComPortExistsShouldRemove
            Write-Error -Message $localizedData.VMComPortRemovingDoesNotSupported
        }
        else
        {
            Write-Verbose -Message $localizedData.VMComPortDoesNotExistNoActionNeeded
        }
    }
}

<#
.SYNOPSIS
    Tests if ITG_xVMComPort resource state is indeed desired state or not.

.PARAMETER Id
    Specifies an unique identifier for the serial port (unused).

.PARAMETER VMName
    Specifies the name of the VM to which serial port will be connected.

.PARAMETER Number
    Specifies a number of serial port.

.PARAMETER Path
    Specifies a named pipe path to which serial port will be connected.

.PARAMETER Ensure
    Specifies if the serial port should be Present or Absent.
#>
Function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    Param (
        [Parameter(Mandatory = $true)]
        [String] $Id,

        [Parameter(Mandatory = $true)]
        [String] $VMName,

        [Parameter(Mandatory = $true)]
        [Int16] $Number,

        [Parameter(Mandatory = $true)]
        [String] $Path = '',

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [String] $Ensure = 'Present'
    )

    $arguments = @{
        VMName = $VMName
        Number = $Number
    }

    Write-Verbose -Message $localizedData.GetVMComPort
    $serialPortExists = Get-VMComPort @arguments -ErrorAction SilentlyContinue

    if ( $Ensure -eq 'Present' )
    {
        if ( $serialPortExists )
        {
            if ( $serialPortExists.Path -ne $Path )
            {
                Write-Verbose -Message $localizedData.VMComPortPathIsDifferent
                return $false
            }
            else
            {
                Write-Verbose -Message $localizedData.VMComPortExistsNoActionNeeded
                return $true
            }
        }
        else
        {
            Write-Verbose -Message $localizedData.VMComPortDoesNotExistShouldAdd
            return $false
        }
    }
    else
    {
        if ( $serialPortExists )
        {
            Write-Verbose -Message $localizedData.VMComPortExistsShouldRemove
            return $false
        }
        else
        {
            Write-Verbose -Message $localizedData.VMComPortDoesNotExistNoActionNeeded
            return $true
        }
    }
}
