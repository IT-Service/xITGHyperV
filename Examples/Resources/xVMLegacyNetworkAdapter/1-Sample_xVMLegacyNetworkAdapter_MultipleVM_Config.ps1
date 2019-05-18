<#PSScriptInfo
.VERSION 1.0.2
.GUID 0d00c0be-77d1-4170-ae48-7ba5fdd807e7
.AUTHOR Sergei S. Betke
.COMPANYNAME Test-St-Petersburg
.COPYRIGHT Sergei S. Betke
.TAGS DSCConfiguration
.LICENSEURI https://github.com/IT-Service/xITGHyperV//blob/master/LICENSE
.PROJECTURI https://github.com/IT-Service/xITGHyperV/
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
.PRIVATEDATA
#>

#Requires -Version 4.0
#Requires -Modules 'xITGHyperV'

<#
    .SYNOPSIS
        Configuration that will create a legacy NICs in VM 'MyVM01'.

    .DESCRIPTION
        Configuration that will create a legacy NICs in VM 'MyVM01'.

    .PARAMETER NodeName
        The names of one or more Hyper-V nodes to compile a configuration for.
        Defaults to 'localhost'.

    .EXAMPLE
        Sample_xVMLegacyNetworkAdapter_MultipleVM

        Compiles a configuration that creates legacy NICs on localhost Hyper-V VM.
#>
Configuration Sample_xVMLegacyNetworkAdapter_MultipleVM_Config
{
    param
    (
        [Parameter()]
        [System.String[]]
        $NodeName = 'localhost'
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xITGHyperV -Name xVMLegacyNetworkAdapter

    node $NodeName
    {
        xVMLegacyNetworkAdapter MyVM01NIC {
            Id = 'MyVM01-NIC'
            Name = 'MyVM01-NIC'
            SwitchName = 'SETSwitch'
            VMName = 'MyVM01'
            Ensure = 'Present'
        }

        xVMLegacyNetworkAdapter MyVM02NIC {
            Id = 'MyVM02-NIC'
            Name = 'NetAdapter'
            SwitchName = 'SETSwitch'
            VMName = 'MyVM02'
            Ensure = 'Present'
        }

        xVMLegacyNetworkAdapter MyVM03NIC {
            Id = 'MyVM03-NIC'
            Name = 'NetAdapter'
            SwitchName = 'SETSwitch'
            VMName = 'MyVM03'
            Ensure = 'Present'
        }
    }
}
