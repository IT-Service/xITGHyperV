#region HEADER
$script:dscModuleName = 'xITGHyperV'
$script:dscResourceName = 'ITG_xVMComPort'

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
        $TestPort = [PSObject]@{
            Id     = 'VM01COM5'
            VMName = 'VM01'
            Number = 5
        }
        $MockPort = [PSObject]@{
            VMName = $TestPort.VMName
            Name   = "COM $($TestPort.Number)"
            Path   = '\\.\pipe\testpipe'
        }

        Describe "$($Global:DSCResourceName)\Get-TargetResource" {

            #Function placeholders
            function Get-VMComPort
            {
            }
            function Set-VMComPort
            {
            }

            Context 'COM Port does not exist' {
                Mock Get-VMComPort -MockWith {}

                It 'should return ensure as absent' {
                    $Result = Get-TargetResource `
                        @TestPort
                    $Result.Ensure | Should Be 'Absent'
                }
                It 'should call the expected mocks' {
                    Assert-MockCalled Get-VMComPort -Exactly 1
                }
            }

            Context 'COM Port exists' {
                Mock Get-VMComPort -MockWith {
                    $MockPort
                }

                It 'should return port properties' {
                    $Result = Get-TargetResource @TestPort
                    $Result.Ensure | Should Be 'Present'
                    $Result.VMName | Should Be $MockPort.VMName
                    $Result.Number | Should Be $TestPort.Number
                    $Result.Path   | Should Be $MockPort.Path
                }
                It 'should call the expected mocks' {
                    Assert-MockCalled Get-VMComPort -Exactly 1
                }
            }
        }

        Describe "$($Global:DSCResourceName)\Set-TargetResource" {

            #Function placeholders
            function Get-VMComPort
            {
            }
            function Set-VMComPort
            {
            }

            $NewPort = [PSObject]@{
                Id     = 'VM01COM1'
                VMName = 'VM01'
                Number = 1
                Path   = '\\.\pipe\testpipe'
                Ensure = 'Present'
            }
            $RemovePort = [PSObject]@{
                Id     = $NewPort.Id
                VMName = $NewPort.VMName
                Number = $NewPort.Number
                Path   = $NewPort.Path
                Ensure = 'Absent'
            }
            $MockPort = [PSObject]@{
                VMName = $NewPort.VMName
                Name   = "COM $($NewPort.Number)"
                Path   = ''
            }
            $NewMockPort = [PSObject]@{
                VMName = $NewPort.VMName
                Name   = "COM $($NewPort.Number)"
                Path   = $NewPort.Path
            }

            Context 'Serial port exists and Path must be set' {
                Mock Get-VMComPort -MockWith {
                    $MockPort
                }
                Mock Set-VMComPort

                It 'should not throw error' {
                    {
                        Set-TargetResource @newPort
                    } | Should Not Throw
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMComPort -Exactly 1
                    Assert-MockCalled -commandName Set-VMComPort -Exactly 1
                }
            }

            Context 'Serial port exists and no action needed' {
                Mock Get-VMComPort -MockWith {
                    $NewMockPort
                }
                Mock Set-VMComPort

                It 'should not throw error' {
                    {
                        Set-TargetResource @newPort
                    } | Should Not Throw
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMComPort -Exactly 1
                    Assert-MockCalled -commandName Set-VMComPort -Exactly 0
                }
            }

            Context 'Serial port does not exist but should' {
                Mock Get-VMComPort
                Mock Set-VMComPort

                It 'should throw error' {
                    {
                        Set-TargetResource @newPort
                    } | Should Throw
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMComPort -Exactly 1
                    Assert-MockCalled -commandName Set-VMComPort -Exactly 0
                }
            }

            Context 'Serial port exists but not should' {
                Mock Get-VMComPort -MockWith {
                    $NewMockPort
                }
                Mock Set-VMComPort

                It 'should throw error' {
                    {
                        Set-TargetResource @RemovePort
                    } | Should Throw
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMComPort -Exactly 1
                    Assert-MockCalled -commandName Set-VMComPort -Exactly 0
                }
            }

            Context 'Serial port does not exists and no action needed' {
                Mock Get-VMComPort
                Mock Set-VMComPort

                It 'should not throw error' {
                    {
                        Set-TargetResource @RemovePort
                    } | Should Not Throw
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMComPort -Exactly 1
                    Assert-MockCalled -commandName Set-VMComPort -Exactly 0
                }
            }

        }

        Describe "$($Global:DSCResourceName)\Test-TargetResource" {

            #Function placeholders
            function Get-VMComPort
            {
            }
            function Set-VMComPort
            {
            }

            $NewPort = [PSObject]@{
                Id     = 'VM01COM1'
                VMName = 'VM01'
                Number = 2
                Path   = '\\.\pipe\testpipe2'
                Ensure = 'Present'
            }
            $RemovePort = [PSObject]@{
                Id     = $NewPort.Id
                VMName = $NewPort.VMName
                Number = $NewPort.Number
                Path   = $NewPort.Path
                Ensure = 'Absent'
            }
            $MockPort = [PSObject]@{
                VMName = $NewPort.VMName
                Name   = "COM $($NewPort.Number)"
                Path   = ''
            }
            $NewMockPort = [PSObject]@{
                VMName = $NewPort.VMName
                Name   = "COM $($NewPort.Number)"
                Path   = $NewPort.Path
            }

            Context 'Serial port does not exist but should' {
                Mock Get-VMComPort

                It 'should return false' {
                    Test-TargetResource @NewPort | Should be $false
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMComPort -Exactly 1
                }
            }

            Context 'Serial port exists and no action needed' {
                Mock Get-VMComPort -MockWith {
                    $NewMockPort
                }

                It 'should return true' {
                    Test-TargetResource @NewPort | Should be $true
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMComPort -Exactly 1
                }
            }

            Context 'Serial port exists but Path is different' {
                Mock Get-VMComPort -MockWith {
                    $MockPort
                }

                It 'should return false' {
                    Test-TargetResource @NewPort | Should be $false
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMComPort -Exactly 1
                }
            }

            Context 'Serial port does not exist and no action needed' {
                Mock Get-VMComPort

                It 'should return true' {
                    Test-TargetResource @RemovePort | Should be $true
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMComPort -Exactly 1
                }
            }

            Context 'Serial port exists but not should' {
                Mock Get-VMComPort -MockWith {
                    $NewMockPort
                }

                It 'should return false' {
                    Test-TargetResource @RemovePort | Should be $false
                }
                It 'should call expected Mocks' {
                    Assert-MockCalled -commandName Get-VMComPort -Exactly 1
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
