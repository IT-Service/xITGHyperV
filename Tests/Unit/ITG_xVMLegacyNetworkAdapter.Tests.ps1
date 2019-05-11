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
            Id                  = 'HostManagement1'
            Name                = 'Management'
            SwitchName          = 'HostSwitch'
            VMName              = 'ManagementOS'
        }

        $TestAdapter = [PSObject]@{
            Id                      = $MockHostAdapter.Id
            Name                    = $MockHostAdapter.Name
            SwitchName              = $MockHostAdapter.SwitchName
            VMName                  = $MockHostAdapter.VMName
        }

        $MockAdapter = [PSObject]@{
            Name                    = $TestAdapter.Name
            SwitchName              = $MockHostAdapter.SwitchName
            IsManagementOs          = $True
            MacAddress              = '14FEB5C6CE98'
        }

        Describe "$($Global:DSCResourceName)\Get-TargetResource" {
            #Function placeholders
            function Get-VMNetworkAdapter { }
            function Set-VMNetworkAdapter { }
            function Remove-VMNetworkAdapter { }
            function Add-VMNetworkAdapter { }
            Context 'Legacy Network Adapter does not exist' {
                Mock Get-VMNetworkAdapter
                It 'should return ensure as absent' {
                    $Result = Get-TargetResource `
                        @TestAdapter
                    $Result.Ensure | Should Be 'Absent'
                }
                It 'should call the expected mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                }
            }

            Context 'Legacy Network Adapter exists' {
                Mock -CommandName Get-VMNetworkAdapter -MockWith {
                    $MockAdapter
                }

                It 'should return adapter properties' {
                    $Result = Get-TargetResource @TestAdapter
                    $Result.Ensure                 | Should Be 'Present'
                    $Result.Name                   | Should Be $TestAdapter.Name
                    $Result.SwitchName             | Should Be $TestAdapter.SwitchName
                    $Result.VMName                 | Should Be 'ManagementOS'
                    $Result.Id                     | Should Be $TestAdapter.Id
                }
                It 'should call the expected mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                }
            }
        }

        Describe "$($Global:DSCResourceName)\Set-TargetResource" {
            #Function placeholders
            function Get-VMNetworkAdapter { }
            function Set-VMNetworkAdapter { }
            function Remove-VMNetworkAdapter { }
            function Add-VMNetworkAdapter { }
            $newAdapter = [PSObject]@{
                Id                      = 'UniqueString'
                Name                    = $TestAdapter.Name
                SwitchName              = $TestAdapter.SwitchName
                VMName                  = 'ManagementOS'
                Ensure                  = 'Present'
            }

            Context 'Adapter does not exist but should' {

                Mock Get-VMNetworkAdapter
                Mock Add-VMNetworkAdapter
                Mock Remove-VMNetworkAdapter

                It 'should not throw error' {
                    {
                        Set-TargetResource @newAdapter
                    } | Should Not Throw
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    Assert-MockCalled -commandName Add-VMNetworkAdapter -Exactly 1
                    Assert-MockCalled -commandName Remove-VMNetworkAdapter -Exactly 0
                }
            }

            Context 'Adapter exists but should not exist' {
                Mock Get-VMNetworkAdapter
                Mock Add-VMNetworkAdapter
                Mock Remove-VMNetworkAdapter

                It 'should not throw error' {
                    {
                        $updateAdapter = $newAdapter.Clone()
                        $updateAdapter.Ensure = 'Absent'
                        Set-TargetResource @updateAdapter
                    } | Should Not Throw
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                    Assert-MockCalled -commandName Add-VMNetworkAdapter -Exactly 0
                    Assert-MockCalled -commandName Remove-VMNetworkAdapter -Exactly 1
                }
            }
        }

        Describe "$($Global:DSCResourceName)\Test-TargetResource" {
            #Function placeholders
            function Get-VMNetworkAdapter { }
            function Set-VMNetworkAdapter { }
            function Remove-VMNetworkAdapter { }
            function Add-VMNetworkAdapter { }
            $newAdapter = [PSObject]@{
                Id                      = 'UniqueString'
                Name                    = $TestAdapter.Name
                SwitchName              = $TestAdapter.SwitchName
                VMName                  = 'ManagementOS'
                Ensure                  = 'Present'
            }

            Context 'Adapter does not exist but should' {
                Mock Get-VMNetworkAdapter

                It 'should return false' {
                    Test-TargetResource @newAdapter | Should be $false
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                }
            }

            Context 'Adapter exists but should not exist' {
                Mock Get-VMNetworkAdapter -MockWith { $MockAdapter }

                It 'should return $false' {
                    $updateAdapter = $newAdapter.Clone()
                    $updateAdapter.Ensure = 'Absent'
                    Test-TargetResource @updateAdapter | Should Be $false
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                }
            }

            Context 'Adapter exists and no action needed' {
                Mock Get-VMNetworkAdapter -MockWith { $MockAdapter }

                It 'should return true' {
                    $updateAdapter = $newAdapter.Clone()
                    Test-TargetResource @updateAdapter | Should Be $true
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
                }
            }

            Context 'Adapter does not exist and no action needed' {
                Mock Get-VMNetworkAdapter

                It 'should return true' {
                    $updateAdapter = $newAdapter.Clone()
                    $updateAdapter.Ensure = 'Absent'
                    Test-TargetResource @updateAdapter | Should Be $true
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMNetworkAdapter -Exactly 1
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

