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

        # Create the Mock Objects that will be used for running tests
        $MockHostAdapter = [PSCustomObject] @{
            Id                       = 'HostManagement1'
            Name                     = 'Management'
            SwitchName               = 'HostSwitch'
            VMName                   = 'ManagementOS'
            DynamicMacAddressEnabled = $True
            IsLegacy                 = $True
        }
        $TestAdapter = [PSObject]@{
            Id         = $MockHostAdapter.Id
            Name       = $MockHostAdapter.Name
            SwitchName = $MockHostAdapter.SwitchName
            VMName     = $MockHostAdapter.VMName
        }
        $MockAdapter = [PSObject]@{
            Name                     = $TestAdapter.Name
            SwitchName               = $TestAdapter.SwitchName
            IsManagementOs           = $True
            VMName                   = $TestAdapter.VMName
            MacAddress               = '14FEB5C6CE98'
            DynamicMacAddressEnabled = $False
            IsLegacy                 = $True
        }
        $MockVMAdapter = [PSObject]@{
            Name                     = $MockAdapter.Name
            SwitchName               = $MockAdapter.SwitchName
            IsManagementOs           = $False
            VMName                   = 'VM01'
            MacAddress               = '14FEB5C6CE98'
            DynamicMacAddressEnabled = $False
            IsLegacy                 = $True
        }
        $TestVMAdapter = [PSObject]@{
            Id         = 'UniqueId'
            Name       = $MockVMAdapter.Name
            SwitchName = $MockVMAdapter.SwitchName
            VMName     = $MockVMAdapter.VMName
        }
        $TestVMAdapter2 = [PSObject]@{
            Id         = $TestVMAdapter.Id
            Name       = $TestVMAdapter.Name
            SwitchName = $TestVMAdapter.SwitchName
            MacAddress = $MockVMAdapter.MacAddress
            VMName     = $TestVMAdapter.VMName
        }
        $newAdapter = [PSObject]@{
            Id         = $TestAdapter.Id
            Name       = $TestAdapter.Name
            SwitchName = $TestAdapter.SwitchName
            VMName     = $TestAdapter.VMName
            Ensure     = 'Present'
        }
        $RemoveAdapter = [PSObject]@{
            Id         = $newAdapter.Id
            Name       = $newAdapter.Name
            SwitchName = $newAdapter.SwitchName
            VMName     = $newAdapter.VMName
            Ensure     = 'Absent'
        }
        $newVMAdapter = [PSObject]@{
            Id         = $TestVMAdapter.Id
            Name       = $TestVMAdapter.Name
            SwitchName = $TestVMAdapter.SwitchName
            VMName     = $TestVMAdapter.VMName
            Ensure     = 'Present'
        }
        $RemoveVMAdapter = [PSObject]@{
            Id         = $newVMAdapter.Id
            Name       = $newVMAdapter.Name
            SwitchName = $newVMAdapter.SwitchName
            VMName     = $newVMAdapter.VMName
            Ensure     = 'Absent'
        }

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
                    Test-TargetResource @newAdapter | Should be $false
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
                Mock Get-VMNetworkAdapter -MockWith {
                    $MockAdapter
                }

                It 'should return $false' {
                    # TODO: исправить!!!
                    $updateAdapter = $newAdapter.Clone()
                    $updateAdapter.Ensure = 'Absent'
                    Test-TargetResource @updateAdapter | Should Be $false
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'VM Adapter exists but should not exist' {
                Mock Get-VMNetworkAdapter -MockWith {
                    $MockVMAdapter
                }

                It 'should return $false' {
                    # TODO: исправить!!!
                    $updateAdapter = $newVMAdapter.Clone()
                    $updateAdapter.Ensure = 'Absent'
                    Test-TargetResource @updateAdapter | Should Be $false
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'Adapter exists and no action needed' {
                Mock Get-VMNetworkAdapter -MockWith {
                    $MockAdapter
                }

                It 'should return true' {
                    # TODO: исправить!!!
                    $updateAdapter = $newAdapter.Clone()
                    Test-TargetResource @updateAdapter | Should Be $true
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'VM Adapter exists and no action needed' {
                Mock Get-VMNetworkAdapter -MockWith {
                    $MockVMAdapter
                }

                It 'should return true' {
                    # TODO: исправить!!!
                    $updateAdapter = $TestVMAdapter2.Clone()
                    Test-TargetResource @updateAdapter | Should Be $true
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'Adapter does not exist and no action needed' {
                Mock Get-VMNetworkAdapter

                It 'should return true' {
                    # TODO: исправить!!!
                    $updateAdapter = $newAdapter.Clone()
                    $updateAdapter.Ensure = 'Absent'
                    Test-TargetResource @updateAdapter | Should Be $true
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    #Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1 -ParameterFilter { $IsLegacy }
                }
            }
            Context 'VM Adapter does not exist and no action needed' {
                Mock Get-VMNetworkAdapter

                It 'should return true' {
                    # TODO: исправить!!!
                    $updateAdapter = $newVMAdapter.Clone()
                    $updateAdapter.Ensure = 'Absent'
                    Test-TargetResource @updateAdapter | Should Be $true
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
