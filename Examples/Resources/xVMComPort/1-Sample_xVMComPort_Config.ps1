<#PSScriptInfo
.VERSION 1.0.2
.GUID 4269486a-fb6f-49cc-a514-12175b3b42b1
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
        Configuration that will attach first serial port in VM 'MyVM01'
        to host named pipe '\\.\pipe\testpipe'.

    .DESCRIPTION
        Configuration that will attach N serial port in VM 'MyVM01'
        to host named pipe '\\.\pipe\testpipe'.

    .PARAMETER NodeName
        The names of one or more Hyper-V nodes to compile a configuration for.
        Defaults to 'localhost'.

    .PARAMETER SerialPortNumber
        The Number of serial port.
        Defaults to 1.

    .PARAMETER PipeName
        The names of pipe.
        Defaults to '\\.\pipe\testpipe'.

    .EXAMPLE
        Sample_xVMComPort

        Compiles a configuration that attach first serial port in VM 'MyVM01'
        to host named pipe '\\.\pipe\testpipe'.
#>
Configuration Sample_xVMComPort_Config
{
    param
    (
        [Parameter()]
        [System.String[]]
        $NodeName = 'localhost',

        [Parameter()]
        [System.UInt16]
        $SerialPortNumber = 1,

        [Parameter()]
        [System.String]
        $PipeName = 'testpipe'
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xITGHyperV -Name xVMComPort

    node $NodeName
    {
        xVMComPort VM01COM1 {
            Id = 'VM01COM01'
            VMName = 'VM01'
            Number = $SerialPortNumber
            Path = "\\.\pipe\${PipeName}"
            Ensure = 'Present'
        }
    }
}
