#region HEADER
$script:dscModuleName = 'xITGHyperV'
$script:dscResourceName = 'ITG_xVMLegacyNetworkAdapter'

# Unit Test Template Version: 1.2.4
$script:moduleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if ( (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
    (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone', 'https://github.com/PowerShell/DscResource.Tests.git', (Join-Path -Path $script:moduleRoot -ChildPath 'DscResource.Tests'))
}

Import-Module -Name (Join-Path -Path $script:moduleRoot -ChildPath (Join-Path -Path 'DSCResource.Tests' -ChildPath 'TestHelper.psm1')) -Force

$TestEnvironment = Initialize-TestEnvironment `
    -DSCModuleName $script:dscModuleName `
    -DSCResourceName $script:dscResourceName `
    -ResourceType 'Mof' `
    -TestType Unit

#endregion HEADER

function Invoke-TestSetup
{
}

function Invoke-TestCleanup
{
    Restore-TestEnvironment -TestEnvironment $TestEnvironment
}

# Begin Testing
try
{
    Invoke-TestSetup

    #region Pester Tests
    InModuleScope $script:dscResourceName {

        Describe "$($Global:DSCResourceName)\Get-TargetResource" {

            #Function placeholders
            function Get-VMNetworkAdapter
            {
            }
            function Set-VMNetworkAdapter
            {
            }
            function Remove-VMNetworkAdapter
            {
            }
            function Add-VMNetworkAdapter
            {
            }

            Context 'Legacy Network Adapter does not exist' {
                Mock Get-VMNetworkAdapter -MockWith {}

                It 'should return ensure as absent' {
                    $Result = Get-TargetResource `
                        -Id 'Id1' `
                        -Name 'HostNIC1' `
                        -SwitchName 'HostSwitch' `
                        -VMName 'ManagementOS'
                    $Result.Ensure | Should Be 'Absent'
                }
                It 'should call the expected mocks' {
                    Assert-MockCalled Get-VMNetworkAdapter -Exactly 1
                    # Assert-MockCalled Get-VMNetworkAdapter -Exactly 1 -parameterFilter { $IsLegacy }
                }
            }
            Context 'Legacy Network Adapter exists' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return [PSObject] @{
                        Name                     = 'HostNIC1'
                        SwitchName               = 'HostSwitch'
                        VMName                   = 'ManagementOS'
                        MacAddress               = '14FEB5C6CE98'
                        DynamicMacAddressEnabled = $False
                        IsLegacy                 = $True
                    }
                }

                It 'should return adapter properties' {
                    $Result = Get-TargetResource `
                        -Id 'Id1' `
                        -Name 'HostNIC1' `
                        -SwitchName 'HostSwitch' `
                        -VMName 'ManagementOS'
                    $Result.Ensure                 | Should Be 'Present'
                    $Result.Name                   | Should Be 'HostNIC1'
                    $Result.SwitchName             | Should Be 'HostSwitch'
                    $Result.VMName                 | Should Be 'ManagementOS'
                    $Result.Id                     | Should Be 'Id1'
                }
                It 'should call the expected mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    # Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'Legacy VM Network Adapter does not exist' {
                Mock Get-VMNetworkAdapter -MockWith {}

                It 'should return ensure as absent' {
                    $Result = Get-TargetResource `
                        -Id 'Id1' `
                        -Name 'HostNIC1' `
                        -SwitchName 'HostSwitch' `
                        -VMName 'VM01'
                    $Result.Ensure | Should Be 'Absent'
                }
                It 'should call the expected mocks' {
                    Assert-MockCalled Get-VMNetworkAdapter -Exactly 1
                    # Assert-MockCalled Get-VMNetworkAdapter -Exactly 1 -parameterFilter { $IsLegacy }
                }
            }
            Context 'Legacy VM Network Adapter exists' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return [PSObject] @{
                        Name                     = 'HostNIC1'
                        SwitchName               = 'HostSwitch'
                        VMName                   = 'VM02'
                        DynamicMacAddressEnabled = $True
                        IsLegacy                 = $True
                    }
                }

                It 'should return adapter properties' {
                    $Result = Get-TargetResource `
                        -Id 'Id3' `
                        -Name 'HostNIC1' `
                        -SwitchName 'HostSwitch' `
                        -VMName 'VM02'
                    $Result.Ensure                 | Should Be 'Present'
                    $Result.Name                   | Should Be 'HostNIC1'
                    $Result.SwitchName             | Should Be 'HostSwitch'
                    $Result.VMName                 | Should Be 'VM02'
                    $Result.Id                     | Should Be 'Id3'
                }
                It 'should call the expected mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    # Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'Get-VMNetworkAdapter return some legacy NIC' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return @(
                        [PSObject] @{
                            Name                     = 'NIC1'
                            SwitchName               = 'Switch'
                            VMName                   = 'VM02'
                            DynamicMacAddressEnabled = $True
                            IsLegacy                 = $True
                        },
                        [PSObject] @{
                            Name                     = 'NIC3'
                            SwitchName               = 'Switch'
                            VMName                   = 'VM02'
                            DynamicMacAddressEnabled = $False
                            MacAddress               = '99999999'
                            IsLegacy                 = $True
                        }
                    )
                }

                It 'should return adapter properties' {
                    $Result = Get-TargetResource `
                        -Id 'Id4' `
                        -Name '*' `
                        -SwitchName 'Switch' `
                        -VMName 'VM02'
                    $Result.Ensure                 | Should Be 'Present'
                    $Result.Name                   | Should Be 'NIC1', 'NIC3'
                    $Result.SwitchName             | Should Be 'Switch'
                    $Result.VMName                 | Should Be 'VM02'
                    $Result.Id                     | Should Be 'Id4'
                }
                It 'should call the expected mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    # Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'Get-VMNetworkAdapter return just non legacy NIC' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return @(
                        [PSObject] @{
                            Name                     = 'NIC1'
                            SwitchName               = 'Switch'
                            VMName                   = 'VM02'
                            DynamicMacAddressEnabled = $True
                            IsLegacy                 = $False
                        },
                        [PSObject] @{
                            Name                     = 'NIC3'
                            SwitchName               = 'Switch'
                            VMName                   = 'VM02'
                            DynamicMacAddressEnabled = $False
                            MacAddress               = '99999999'
                            IsLegacy                 = $False
                        }
                    )
                }

                It 'should return adapter properties' {
                    $Result = Get-TargetResource `
                        -Id 'Id3' `
                        -Name '*' `
                        -SwitchName 'Switch' `
                        -VMName 'VM02'
                    $Result.Ensure | Should Be 'Absent'
                }
                It 'should call the expected mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    # Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }

        }

        Describe "$($Global:DSCResourceName)\Set-TargetResource" {

            #Function placeholders
            function Get-VMNetworkAdapter
            {
            }
            function Set-VMNetworkAdapter
            {
            }
            function Remove-VMNetworkAdapter
            {
            }
            function Add-VMNetworkAdapter
            {
            }
            function Connect-VMNetworkAdapter
            {
            }

            Context 'Adapter does not exist but should' {
                Mock Get-VMNetworkAdapter
                Mock Add-VMNetworkAdapter
                Mock Remove-VMNetworkAdapter

                It 'should not throw error' {
                    {
                        Set-TargetResource `
                            -Id 'Id04' `
                            -Name 'NIC04' `
                            -SwitchName 'Switch04' `
                            -VMName 'ManagementOS' `
                            -Ensure 'Present'
                    } | Should Not Throw
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    Assert-MockCalled -commandName Add-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                    #Assert-MockCalled -commandName Add-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                    Assert-MockCalled -commandName Remove-VMNetworkAdapter -Exactly 0
                }
            }
            Context 'VM Adapter does not exist but should' {
                Mock Get-VMNetworkAdapter
                Mock Add-VMNetworkAdapter
                Mock Remove-VMNetworkAdapter

                It 'should not throw error' {
                    {
                        Set-TargetResource `
                            -Id 'Id04' `
                            -Name 'NIC04' `
                            -SwitchName 'Switch04' `
                            -VMName 'VM04' `
                            -Ensure 'Present'
                    } | Should Not Throw
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    Assert-MockCalled -commandName Add-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                    #Assert-MockCalled -commandName Add-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                    Assert-MockCalled -commandName Remove-VMNetworkAdapter -Exactly 0
                }
            }
            Context 'Adapter exists but should not exist' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return [PSObject] @{
                        Name       = 'NIC04'
                        SwitchName = 'Switch04'
                        VMName     = 'ManagementOS'
                        IsLegacy   = $True
                    }
                }
                Mock Add-VMNetworkAdapter
                Mock Remove-VMNetworkAdapter

                It 'should not throw error' {
                    {
                        Set-TargetResource `
                            -Id 'Id04' `
                            -Name 'NIC04' `
                            -SwitchName 'Switch04' `
                            -VMName 'ManagementOS' `
                            -Ensure 'Absent'
                    } | Should Not Throw
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                    Assert-MockCalled -commandName Add-VMNetworkAdapter -Exactly 0
                    Assert-MockCalled -commandName Remove-VMNetworkAdapter -Exactly 1
                }
            }
            Context 'VM Adapter exists but should not exist' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return [PSObject] @{
                        Name                     = 'NIC04'
                        SwitchName               = 'Switch04'
                        VMName                   = 'VM04'
                        DynamicMacAddressEnabled = $True
                        IsLegacy                 = $True
                    }
                }
                Mock Add-VMNetworkAdapter
                Mock Remove-VMNetworkAdapter

                It 'should not throw error' {
                    {
                        Set-TargetResource `
                            -Id 'Id04' `
                            -Name 'NIC04' `
                            -SwitchName 'Switch04' `
                            -VMName 'VM04' `
                            -Ensure 'Absent'
                    } | Should Not Throw
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                    Assert-MockCalled -commandName Add-VMNetworkAdapter -Exactly 0
                    Assert-MockCalled -commandName Remove-VMNetworkAdapter -Exactly 1
                }
            }
            Context 'VM Adapter exists but switch different' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return [PSObject] @{
                        Name                     = 'NIC04'
                        SwitchName               = 'SwitchDifferent'
                        VMName                   = 'VM04'
                        DynamicMacAddressEnabled = $True
                        IsLegacy                 = $True
                    }
                }
                Mock Add-VMNetworkAdapter
                Mock Remove-VMNetworkAdapter
                Mock Connect-VMNetworkAdapter

                It 'should not throw error' {
                    {
                        Set-TargetResource `
                            -Id 'Id04' `
                            -Name 'NIC04' `
                            -SwitchName 'Switch04' `
                            -VMName 'VM04' `
                            -Ensure 'Present'
                    } | Should Not Throw
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                    Assert-MockCalled -commandName Add-VMNetworkAdapter -Exactly 0
                    Assert-MockCalled -commandName Remove-VMNetworkAdapter -Exactly 0
                    Assert-MockCalled -commandName Connect-VMNetworkAdapter -Exactly 1
                }
            }
            Context 'VM Adapter exists but with different MAC address' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return [PSObject] @{
                        Name                     = 'NIC04'
                        SwitchName               = 'Switch04'
                        VMName                   = 'VM04'
                        DynamicMacAddressEnabled = $False
                        MacAddress               = '99999998'
                        IsLegacy                 = $True
                    }
                }
                Mock Add-VMNetworkAdapter
                Mock Remove-VMNetworkAdapter
                Mock Set-VMNetworkAdapter
                Mock Connect-VMNetworkAdapter

                It 'should not throw error' {
                    {
                        Set-TargetResource `
                            -Id 'Id04' `
                            -Name 'NIC04' `
                            -SwitchName 'Switch04' `
                            -MacAddress '99999999' `
                            -VMName 'VM04' `
                            -Ensure 'Present'
                    } | Should Not Throw
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                    Assert-MockCalled -commandName Add-VMNetworkAdapter -Exactly 0
                    Assert-MockCalled -commandName Remove-VMNetworkAdapter -Exactly 0
                    Assert-MockCalled -commandName Set-VMNetworkAdapter -Exactly 1
                    Assert-MockCalled -commandName Connect-VMNetworkAdapter -Exactly 0
                }
            }
            Context 'VM Adapter exists but with dynamic MAC address and different switch' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return [PSObject] @{
                        Name                     = 'NIC04'
                        SwitchName               = 'SwitchDifferent'
                        VMName                   = 'VM04'
                        DynamicMacAddressEnabled = $True
                        IsLegacy                 = $True
                    }
                }
                Mock Add-VMNetworkAdapter
                Mock Remove-VMNetworkAdapter
                Mock Set-VMNetworkAdapter
                Mock Connect-VMNetworkAdapter

                It 'should not throw error' {
                    {
                        Set-TargetResource `
                            -Id 'Id04' `
                            -Name 'NIC04' `
                            -SwitchName 'Switch04' `
                            -MacAddress '99999999' `
                            -VMName 'VM04' `
                            -Ensure 'Present'
                    } | Should Not Throw
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                    Assert-MockCalled -commandName Add-VMNetworkAdapter -Exactly 0
                    Assert-MockCalled -commandName Remove-VMNetworkAdapter -Exactly 0
                    Assert-MockCalled -commandName Set-VMNetworkAdapter -Exactly 1
                    Assert-MockCalled -commandName Connect-VMNetworkAdapter -Exactly 1
                }
            }
            Context 'VM Adapter exists but with static MAC address' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return [PSObject] @{
                        Name                     = 'NIC04'
                        SwitchName               = 'Switch04'
                        VMName                   = 'VM04'
                        DynamicMacAddressEnabled = $False
                        MacAddress               = '99999999'
                        IsLegacy                 = $True
                    }
                }
                Mock Add-VMNetworkAdapter
                Mock Remove-VMNetworkAdapter
                Mock Set-VMNetworkAdapter
                Mock Connect-VMNetworkAdapter

                It 'should not throw error' {
                    {
                        Set-TargetResource `
                            -Id 'Id04' `
                            -Name 'NIC04' `
                            -SwitchName 'Switch04' `
                            -VMName 'VM04' `
                            -Ensure 'Present'
                    } | Should Not Throw
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                    Assert-MockCalled -commandName Add-VMNetworkAdapter -Exactly 0
                    Assert-MockCalled -commandName Remove-VMNetworkAdapter -Exactly 0
                    Assert-MockCalled -commandName Set-VMNetworkAdapter -Exactly 1
                    Assert-MockCalled -commandName Connect-VMNetworkAdapter -Exactly 0
                }
            }
            Context 'VM Adapter does not exists but should with static MAC address' {
                Mock Get-VMNetworkAdapter
                Mock Add-VMNetworkAdapter
                Mock Remove-VMNetworkAdapter
                Mock Set-VMNetworkAdapter
                Mock Connect-VMNetworkAdapter

                It 'should not throw error' {
                    {
                        Set-TargetResource `
                            -Id 'Id04' `
                            -Name 'NIC04' `
                            -SwitchName 'Switch04' `
                            -MacAddress '99999999' `
                            -VMName 'VM04' `
                            -Ensure 'Present'
                    } | Should Not Throw
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                    Assert-MockCalled -commandName Add-VMNetworkAdapter -Exactly 1
                    Assert-MockCalled -commandName Remove-VMNetworkAdapter -Exactly 0
                    Assert-MockCalled -commandName Set-VMNetworkAdapter -Exactly 0
                    Assert-MockCalled -commandName Connect-VMNetworkAdapter -Exactly 0
                }
            }
            Context 'Get-VMNetworkAdapter return some legacy NIC but should not exist' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return @(
                        [PSObject] @{
                            Name                     = 'NIC1'
                            SwitchName               = 'Switch'
                            VMName                   = 'VM02'
                            DynamicMacAddressEnabled = $True
                            IsLegacy                 = $True
                        },
                        [PSObject] @{
                            Name                     = 'NIC3'
                            SwitchName               = 'Switch'
                            VMName                   = 'VM02'
                            DynamicMacAddressEnabled = $False
                            MacAddress               = '99999999'
                            IsLegacy                 = $True
                        }
                    )
                }
                Mock Add-VMNetworkAdapter
                Mock Remove-VMNetworkAdapter
                Mock Set-VMNetworkAdapter
                Mock Connect-VMNetworkAdapter

                It 'should not throw error' {
                    {
                        Set-TargetResource `
                            -Id 'Id4' `
                            -Name '*' `
                            -SwitchName 'Switch' `
                            -VMName 'VM02' `
                            -Ensure 'Absent'
                    } | Should Not Throw
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                    Assert-MockCalled -commandName Add-VMNetworkAdapter -Exactly 0
                    Assert-MockCalled -commandName Remove-VMNetworkAdapter -Exactly 2
                    Assert-MockCalled -commandName Set-VMNetworkAdapter -Exactly 0
                    Assert-MockCalled -commandName Connect-VMNetworkAdapter -Exactly 0
                }
            }
            Context 'Get-VMNetworkAdapter return just non legacy NICs but should exist legacy NICs' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return @(
                        [PSObject] @{
                            Name                     = 'NIC1'
                            SwitchName               = 'Switch'
                            VMName                   = 'VM02'
                            DynamicMacAddressEnabled = $True
                            IsLegacy                 = $False
                        },
                        [PSObject] @{
                            Name                     = 'NIC3'
                            SwitchName               = 'Switch'
                            VMName                   = 'VM02'
                            DynamicMacAddressEnabled = $False
                            MacAddress               = '99999999'
                            IsLegacy                 = $False
                        }
                    )
                }
                Mock Add-VMNetworkAdapter
                Mock Remove-VMNetworkAdapter
                Mock Set-VMNetworkAdapter
                Mock Connect-VMNetworkAdapter

                It 'should not throw error' {
                    {
                        Set-TargetResource `
                            -Id 'Id4' `
                            -Name 'NIC1' `
                            -SwitchName 'Switch' `
                            -VMName 'VM02' `
                            -Ensure 'Present'
                    } | Should Not Throw
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                    Assert-MockCalled -commandName Add-VMNetworkAdapter -Exactly 1
                    Assert-MockCalled -commandName Remove-VMNetworkAdapter -Exactly 0
                    Assert-MockCalled -commandName Set-VMNetworkAdapter -Exactly 0
                    Assert-MockCalled -commandName Connect-VMNetworkAdapter -Exactly 0
                }
            }
        }

        Describe "$($Global:DSCResourceName)\Test-TargetResource" {

            #Function placeholders
            function Get-VMNetworkAdapter
            {
            }
            function Set-VMNetworkAdapter
            {
            }
            function Remove-VMNetworkAdapter
            {
            }
            function Add-VMNetworkAdapter
            {
            }

            Context 'Adapter does not exist but should' {
                Mock Get-VMNetworkAdapter

                It 'should return false' {
                    Test-TargetResource `
                        -Id 'Id04' `
                        -Name 'NIC04' `
                        -SwitchName 'Switch04' `
                        -VMName 'ManagementOS' `
                        -Ensure 'Present' `
                        | Should be $false
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'VM Adapter does not exist but should' {
                Mock Get-VMNetworkAdapter

                It 'should return false' {
                    Test-TargetResource `
                        -Id 'Id04' `
                        -Name 'NIC04' `
                        -SwitchName 'Switch04' `
                        -VMName 'VM04' `
                        -Ensure 'Present' `
                        | Should be $false
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'Adapter exists but should not exist' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return [PSObject] @{
                        Name       = 'NIC10'
                        SwitchName = 'Switch10'
                        VMName     = 'ManagementOS'
                        IsLegacy   = $True
                    }
                }

                It 'should return $false' {
                    Test-TargetResource `
                        -Id 'Id10' `
                        -Name 'NIC10' `
                        -SwitchName 'Switch10' `
                        -VMName 'ManagementOS' `
                        -Ensure 'Absent' `
                        | Should be $false
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'VM Adapter exists but should not exist' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return [PSObject] @{
                        Name       = 'NIC10'
                        SwitchName = 'Switch10'
                        VMName     = 'VM10'
                        IsLegacy   = $True
                    }
                }

                It 'should return $false' {
                    Test-TargetResource `
                        -Id 'Id10' `
                        -Name 'NIC10' `
                        -SwitchName 'Switch10' `
                        -VMName 'VM10' `
                        -Ensure 'Absent' `
                        | Should be $false
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'Adapter exists and no action needed' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return [PSObject] @{
                        Name       = 'NIC10'
                        SwitchName = 'Switch10'
                        VMName     = 'ManagementOS'
                        IsLegacy   = $True
                    }
                }

                It 'should return true' {
                    Test-TargetResource `
                        -Id 'Id10' `
                        -Name 'NIC10' `
                        -SwitchName 'Switch10' `
                        -VMName 'ManagementOS' `
                        -Ensure 'Present' `
                        | Should be $true
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'VM Adapter exists and no action needed' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return [PSObject] @{
                        Name                     = 'NIC10'
                        SwitchName               = 'Switch10'
                        VMName                   = 'VM10'
                        DynamicMacAddressEnabled = $True
                        IsLegacy                 = $True
                    }
                }

                It 'should return true' {
                    Test-TargetResource `
                        -Id 'Id10' `
                        -Name 'NIC10' `
                        -SwitchName 'Switch10' `
                        -VMName 'VM10' `
                        -Ensure 'Present' `
                        | Should be $true
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'VM Adapter exists but with dynamic MAC address' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return [PSObject] @{
                        Name                     = 'NIC10'
                        SwitchName               = 'Switch10'
                        VMName                   = 'VM10'
                        DynamicMacAddressEnabled = $True
                        IsLegacy                 = $True
                    }
                }

                It 'should return true' {
                    Test-TargetResource `
                        -Id 'Id10' `
                        -Name 'NIC10' `
                        -SwitchName 'Switch10' `
                        -VMName 'VM10' `
                        -MacAddress '14FEB5C6CE98' `
                        -Ensure 'Present' `
                        | Should be $False
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'VM Adapter exists but with static MAC address' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return [PSObject] @{
                        Name                     = 'NIC10'
                        SwitchName               = 'Switch10'
                        VMName                   = 'VM10'
                        DynamicMacAddressEnabled = $False
                        MacAddress               = '14FEB5C6CE98'
                        IsLegacy                 = $True
                    }
                }

                It 'should return true' {
                    Test-TargetResource `
                        -Id 'Id10' `
                        -Name 'NIC10' `
                        -SwitchName 'Switch10' `
                        -VMName 'VM10' `
                        -Ensure 'Present' `
                        | Should be $False
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'VM Adapter exists but with different MAC address' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return [PSObject] @{
                        Name                     = 'NIC10'
                        SwitchName               = 'Switch10'
                        VMName                   = 'VM10'
                        DynamicMacAddressEnabled = $false
                        MacAddress               = '14FEB5C6CE99'
                        IsLegacy                 = $True
                    }
                }

                It 'should return true' {
                    Test-TargetResource `
                        -Id 'Id10' `
                        -Name 'NIC10' `
                        -SwitchName 'Switch10' `
                        -VMName 'VM10' `
                        -MacAddress '14FEB5C6CE98' `
                        -Ensure 'Present' `
                        | Should be $False
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'VM Adapter exists but with different switch' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return [PSObject] @{
                        Name                     = 'NIC10'
                        SwitchName               = 'SwitchDifferent'
                        VMName                   = 'VM10'
                        DynamicMacAddressEnabled = $False
                        MacAddress               = '14FEB5C6CE98'
                        IsLegacy                 = $True
                    }
                }

                It 'should return true' {
                    Test-TargetResource `
                        -Id 'Id10' `
                        -Name 'NIC10' `
                        -SwitchName 'Switch10' `
                        -VMName 'VM10' `
                        -MacAddress '14FEB5C6CE98' `
                        -Ensure 'Present' `
                        | Should be $False
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'Adapter does not exist and no action needed' {
                Mock Get-VMNetworkAdapter

                It 'should return true' {
                    Test-TargetResource `
                        -Id 'Id10' `
                        -Name 'NIC10' `
                        -SwitchName 'Switch10' `
                        -VMName 'VM10' `
                        -Ensure 'Absent' `
                        | Should be $true
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'VM Adapter does not exist and no action needed' {
                Mock Get-VMNetworkAdapter

                It 'should return true' {
                    Test-TargetResource `
                        -Id 'Id10' `
                        -Name 'NIC10' `
                        -SwitchName 'Switch10' `
                        -VMName 'VM10' `
                        -Ensure 'Absent' `
                        | Should be $true
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'Get-VMNetworkAdapter return some legacy NIC' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return @(
                        [PSObject] @{
                            Name                     = 'NIC1'
                            SwitchName               = 'Switch'
                            VMName                   = 'VM02'
                            DynamicMacAddressEnabled = $True
                            IsLegacy                 = $True
                        },
                        [PSObject] @{
                            Name                     = 'NIC3'
                            SwitchName               = 'Switch'
                            VMName                   = 'VM02'
                            DynamicMacAddressEnabled = $False
                            MacAddress               = '99999999'
                            IsLegacy                 = $True
                        }
                    )
                }

                It 'should return true' {
                    Test-TargetResource `
                        -Id 'Id4' `
                        -Name '*' `
                        -SwitchName 'Switch' `
                        -VMName 'VM02' `
                        -Ensure 'Present' `
                        | Should be $true
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'Get-VMNetworkAdapter return just non legacy NIC' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    return @(
                        [PSObject] @{
                            Name                     = 'NIC1'
                            SwitchName               = 'Switch'
                            VMName                   = 'VM02'
                            DynamicMacAddressEnabled = $True
                            IsLegacy                 = $False
                        },
                        [PSObject] @{
                            Name                     = 'NIC3'
                            SwitchName               = 'Switch'
                            VMName                   = 'VM02'
                            DynamicMacAddressEnabled = $False
                            MacAddress               = '99999999'
                            IsLegacy                 = $False
                        }
                    )
                }

                It 'should return false' {
                    Test-TargetResource `
                        -Id 'Id4' `
                        -Name '*' `
                        -SwitchName 'Switch' `
                        -VMName 'VM02' `
                        -Ensure 'Present' `
                        | Should be $false
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
        }

    }
    #endregion Pester Tests
}
finally
{
    Invoke-TestCleanup
}
