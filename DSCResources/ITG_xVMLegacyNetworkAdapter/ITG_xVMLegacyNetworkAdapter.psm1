$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:resourceHelperModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'DscResource.Common'
Import-Module -Name (Join-Path -Path $script:resourceHelperModulePath -ChildPath 'DscResource.Common.psm1')

$script:localizedData = Get-LocalizedData -ResourceName 'ITG_xVMLegacyNetworkAdapter'

<#
.SYNOPSIS
    Gets ITG_xVMLegacyNetworkAdapter resource current state.

.PARAMETER Id
    Specifies an unique identifier for the network adapter.

.PARAMETER Name
    Specifies a name for the network adapter that needs to be connected to a VM or management OS.

.PARAMETER SwitchName
    Specifies the name of the switch to which the new VM network adapter will be connected.

.PARAMETER VMName
    Specifies the name of the VM to which the network adapter will be connected.
    Specify VMName as ManagementOS if you wish to connect the adapter to host OS.
#>
Function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    Param (
        [Parameter(Mandatory = $true)]
        [String] $Id,

        [Parameter(Mandatory = $true)]
        [String] $Name,

        [Parameter(Mandatory = $true)]
        [String] $SwitchName,

        [Parameter(Mandatory = $true)]
        [String] $VMName
    )

    $configuration = @{
        Id         = $Id
        Name       = $Name
        SwitchName = $SwitchName
        VMName     = $VMName
    }

    $arguments = @{
        Name = $Name
    }

    if ( $VMName -ne 'ManagementOS' )
    {
        $arguments.Add( 'VMName', $VMName )
    }
    else
    {
        $arguments.Add( 'ManagementOS', $true )
        $arguments.Add( 'SwitchName', $SwitchName )
    }

    Write-Verbose -Message $localizedData.GetVMNetAdapter
    $netAdapters = @( Get-VMNetworkAdapter @arguments -ErrorAction SilentlyContinue | Where-Object { $_.IsLegacy } )

    if ( $netAdapters.Count -gt 0 )
    {
        Write-Verbose -Message $localizedData.FoundVMNetAdapter
        $configuration.Add( 'Ensure', 'Present' )
        if ( $netAdapters.Count -gt 1 )
        {
            $configuration['Name'] = @( $netAdapters | ForEach-Object { $_.Name } )
        }
        else
        {
            $netAdapter = $netAdapters[0]
            if ( $VMName -eq 'ManagementOS' )
            {
                $configuration.Add( 'MacAddress', $netAdapter.MacAddress )
                $configuration.Add( 'DynamicMacAddress', $false )
            }
            elseif ( $netAdapter.VMName )
            {
                $configuration.Add( 'MacAddress', $netAdapter.MacAddress )
                $configuration.Add( 'DynamicMacAddress', $netAdapter.DynamicMacAddressEnabled )
            }
        }
    }
    else
    {
        Write-Verbose -Message $localizedData.NoVMNetAdapterFound
        $configuration.Add( 'Ensure', 'Absent' )
    }

    return $configuration
}

<#
.SYNOPSIS
    Sets ITG_xVMLegacyNetworkAdapter resource state.

.PARAMETER Id
    Specifies an unique identifier for the network adapter.

.PARAMETER Name
    Specifies a name for the network adapter that needs to be connected to a VM or management OS.

.PARAMETER SwitchName
    Specifies the name of the switch to which the new VM network adapter will be connected.

.PARAMETER VMName
    Specifies the name of the VM to which the network adapter will be connected.
    Specify VMName as ManagementOS if you wish to connect the adapter to host OS.

.PARAMETER MacAddress
    Specifies the MAC address for the network adapter. This is not applicable if VMName
    is set to ManagementOS. Use this parameter to specify a static MAC address.

.PARAMETER Ensure
    Specifies if the network adapter should be Present or Absent.
#>
Function Set-TargetResource
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String] $Id,

        [Parameter(Mandatory = $true)]
        [String] $Name,

        [Parameter(Mandatory = $true)]
        [String] $SwitchName,

        [Parameter(Mandatory = $true)]
        [String] $VMName,

        [Parameter()]
        [String] $MacAddress,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [String] $Ensure = 'Present'
    )

    $arguments = @{
        Name = $Name
    }

    if ( $VMName -ne 'ManagementOS' )
    {
        $arguments.Add( 'VMName', $VMName )
    }
    else
    {
        $arguments.Add( 'ManagementOS', $true )
        $arguments.Add( 'SwitchName', $SwitchName )
    }

    Write-Verbose -Message $localizedData.GetVMNetAdapter
    $netAdapters = @( Get-VMNetworkAdapter @arguments -ErrorAction SilentlyContinue | Where-Object { $_.IsLegacy } )

    if ( $Ensure -eq 'Present' )
    {
        if ( $netAdapters.Count -gt 0 )
        {
            Write-Verbose -Message $localizedData.FoundVMNetAdapter
            foreach ( $netAdapter in $netAdapters )
            {
                if ( $VMName -ne 'ManagementOS' )
                {
                    if ( $MacAddress )
                    {
                        if ( $netAdapter.DynamicMacAddressEnabled )
                        {
                            Write-Verbose -Message $localizedData.EnableStaticMacAddress
                            $updateMacAddress = $true
                        }
                        elseif ( $MacAddress -ne $netAdapter.StaicMacAddress )
                        {
                            Write-Verbose -Message $localizedData.EnableStaticMacAddress
                            $updateMacAddress = $true
                        }
                    }
                    else
                    {
                        if ( -not $netAdapter.DynamicMacAddressEnabled )
                        {
                            Write-Verbose -Message $localizedData.EnableDynamicMacAddress
                            $updateMacAddress = $true
                        }
                    }

                    if ( $netAdapter.SwitchName -ne $SwitchName )
                    {
                        Connect-VMNetworkAdapter -VMNetworkAdapter $netAdapter -SwitchName $SwitchName -ErrorAction Stop -Verbose
                    }

                    if ( $updateMacAddress )
                    {
                        Write-Verbose -Message $localizedData.PerformVMNetModify

                        $setArguments = @{ }
                        if ( $MacAddress )
                        {
                            $setArguments.Add( 'StaticMacAddress', $MacAddress )
                        }
                        else
                        {
                            $setArguments.Add( 'DynamicMacAddress', $true )
                        }
                        Set-VMNetworkAdapter -VMNetworkAdapter $netAdapter @setArguments -ErrorAction Stop -Verbose
                    }
                }
            }
        }
        else
        {
            if ( $VMName -ne 'ManagementOS' )
            {
                if ( -not $MacAddress )
                {
                    $arguments.Add( 'DynamicMacAddress', $true )
                }
                else
                {
                    $arguments.Add( 'StaticMacAddress', $MacAddress )
                }
                $arguments.Add( 'SwitchName', $SwitchName )
            }
            Add-VMNetworkAdapter @arguments -IsLegacy $true -ErrorAction Stop -Verbose
        }
    }
    else
    {
        $netAdapters | Remove-VMNetworkAdapter -ErrorAction Stop -Verbose
    }
}

<#
.SYNOPSIS
    Tests if ITG_xVMLegacyNetworkAdapter resource state is indeed desired state or not.

.PARAMETER Id
    Specifies an unique identifier for the network adapter.

.PARAMETER Name
    Specifies a name for the network adapter that needs to be connected to a VM or management OS.

.PARAMETER SwitchName
    Specifies the name of the switch to which the new VM network adapter will be connected.

.PARAMETER VMName
    Specifies the name of the VM to which the network adapter will be connected.
    Specify VMName as ManagementOS if you wish to connect the adapter to host OS.

.PARAMETER MacAddress
    Specifies the MAC address for the network adapter. This is not applicable if VMName
    is set to ManagementOS. Use this parameter to specify a static MAC address.

.PARAMETER Ensure
    Specifies if the network adapter should be Present or Absent.
#>
Function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    Param (
        [Parameter(Mandatory = $true)]
        [String] $Id,

        [Parameter(Mandatory = $true)]
        [String] $Name,

        [Parameter(Mandatory = $true)]
        [String] $SwitchName,

        [Parameter(Mandatory = $true)]
        [String] $VMName,

        [Parameter()]
        [String] $MacAddress,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [String] $Ensure = 'Present'
    )

    $arguments = @{
        Name = $Name
    }

    if ( $VMName -ne 'ManagementOS' )
    {
        $arguments.Add( 'VMName', $VMName )
    }
    else
    {
        $arguments.Add( 'ManagementOS', $true )
        $arguments.Add( 'SwitchName', $SwitchName )
    }

    Write-Verbose -Message $localizedData.GetVMNetAdapter
    $netAdapters = @( Get-VMNetworkAdapter @arguments -ErrorAction SilentlyContinue | Where-Object { $_.IsLegacy } )

    if ( $Ensure -eq 'Present' )
    {
        if ( $netAdapters.Count -gt 0 )
        {
            foreach ( $netAdapter in $netAdapters )
            {
                if ( $VMName -ne 'ManagementOS' )
                {
                    if ( $MacAddress )
                    {
                        if ( $netAdapter.DynamicMacAddressEnabled )
                        {
                            Write-Verbose -Message $localizedData.EnableStaticMacAddress
                            return $false
                        }
                        elseif ( $netAdapter.MacAddress -ne $MacAddress )
                        {
                            Write-Verbose -Message $localizedData.StaticAddressDoesNotMatch
                            return $false
                        }
                    }
                    else
                    {
                        if ( -not $netAdapter.DynamicMacAddressEnabled )
                        {
                            Write-Verbose -Message $localizedData.EnableDynamicMacAddress
                            return $false
                        }
                    }

                    if ( $netAdapter.SwitchName -ne $SwitchName )
                    {
                        Write-Verbose -Message $localizedData.SwitchIsDifferent
                        return $false
                    }
                    else
                    {
                        Write-Verbose -Message $localizedData.VMNetAdapterExistsNoActionNeeded
                        return $true
                    }
                }
            }
            Write-Verbose -Message $localizedData.VMNetAdapterExistsNoActionNeeded
            return $true
        }
        else
        {
            Write-Verbose -Message $localizedData.VMNetAdapterDoesNotExistShouldAdd
            return $false
        }
    }
    else
    {
        if ( $netAdapters.Count -gt 0 )
        {
            Write-Verbose -Message $localizedData.VMNetAdapterExistsShouldRemove
            return $false
        }
        else
        {
            Write-Verbose -Message $localizedData.VMNetAdapterDoesNotExistNoActionNeeded
            return $true
        }
    }
}
