# xITGHyperV

The **xITGHyperV** module based on xHyper-V and contains DSC resources for
 deployment and configuration of virtual machines and related resources.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/).

## Branches

### master

[![Build status](https://ci.appveyor.com/api/projects/status/q0dap46majxqxc3q/branch/master?svg=true)](https://ci.appveyor.com/project/IT-Service/xITGHyperV/branch/master)
[![codecov](https://codecov.io/gh/IT-Service/xITGHyperV/branch/master/graph/badge.svg)](https://codecov.io/gh/IT-Service/xITGHyperV/branch/master)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/xITGHyperV.svg)](https://www.powershellgallery.com/packages/xITGHyperV/)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/xITGHyperV.svg)](https://www.powershellgallery.com/packages/xITGHyperV/)

This is the branch containing the latest release - no contributions should be
made directly to this branch.

### develop

[![Build status](https://ci.appveyor.com/api/projects/status/q0dap46majxqxc3q/branch/develop?svg=true)](https://ci.appveyor.com/project/IT-Service/xITGHyperV/branch/develop)
[![codecov](https://codecov.io/gh/IT-Service/xITGHyperV/branch/develop/graph/badge.svg)](https://codecov.io/gh/IT-Service/xITGHyperV/branch/develop)

This is the development branch to which contributions should be proposed by
contributors as pull requests. This development branch will periodically be
merged to the master branch, and be released to [PowerShell Gallery](https://www.powershellgallery.com/).

## Contributing

Please check out common DSC Resources [contributing guidelines](CONTRIBUTING.md).

## Change log

A full list of changes in each version can be found in the [change log](CHANGELOG.md).

## Resources

* [**xVMLegacyNetworkAdapter**](#xvmlegacynetworkadapter) manages legacy
 VM network adapters attached to a Hyper-V virtual machine.
* [**xVMNonLegacyNetworkAdapter**](#xvmnonlegacynetworkadapter) manages non legacy
 VM network adapters attached to a Hyper-V virtual machine.
* [**xVMComPort**](#xvmcomport) manages
 VM serial ports attached to a Hyper-V virtual machine.

### xVMLegacyNetworkAdapter

Manages legacy VM Network adapters attached to a Hyper-V virtual machine.

#### Requirements for xVMLegacyNetworkAdapter

* The Hyper-V Role has to be installed on the machine.
* The Hyper-V PowerShell module has to be installed on the machine.

#### Parameters for xVMLegacyNetworkAdapter

* **`[String]` Id** _(Key)_: Unique string for identifying the resource instance.
* **`[String]` Name** _(Required)_: Name of the network adapter as it appears either
 in the management OS or attached to a VM.
* **`[String]` SwitchName** _(Required)_: Virtual Switch name to connect to.
* **`[String]` VMName** _(Required)_: Name of the VM to attach to.
 If you want to attach new VM Network adapter to the management OS,
 set this property to 'Management OS'.
* **`[String]` MacAddress** _(Write)_: Use this to specify a Static MAC Address.
 If this parameter is not specified, dynamic MAC Address will be set.
* **`[String]` Ensure** _(Write)_: Ensures that the VM Network Adapter is
 Present or Absent. The default value is Present. { *Present* | Absent }.

#### Read-Only Properties from Get-TargetResource for xVMLegacyNetworkAdapter

* **`[Boolean]` DynamicMacAddress** _(Read)_: Does the VM Network Adapter use a
 Dynamic MAC Address.

#### Examples

* [Add multiple VM Network adapters to a VM](https://github.com/IT-Service/xITGHyperV/blob/feature/xITGHyperV/Examples/Resources/xVMLegacyNetworkAdapter/1-Sample_xVMLegacyNetworkAdapter_MultipleVM_Config.ps1)

### xVMNonLegacyNetworkAdapter

Manages non legacy VM Network adapters attached to a Hyper-V virtual machine.

#### Requirements for xVMNonLegacyNetworkAdapter

* The Hyper-V Role has to be installed on the machine.
* The Hyper-V PowerShell module has to be installed on the machine.

#### Parameters for xVMNonLegacyNetworkAdapter

* **`[String]` Id** _(Key)_: Unique string for identifying the resource instance.
* **`[String]` Name** _(Required)_: Name of the network adapter as it appears either
 in the management OS or attached to a VM.
* **`[String]` SwitchName** _(Required)_: Virtual Switch name to connect to.
* **`[String]` VMName** _(Required)_: Name of the VM to attach to.
 If you want to attach new VM Network adapter to the management OS,
 set this property to 'Management OS'.
* **`[String]` MacAddress** _(Write)_: Use this to specify a Static MAC Address.
 If this parameter is not specified, dynamic MAC Address will be set.
* **`[String]` Ensure** _(Write)_: Ensures that the VM Network Adapter is
 Present or Absent. The default value is Present. { *Present* | Absent }.

#### Read-Only Properties from Get-TargetResource for xVMNonLegacyNetworkAdapter

* **`[Boolean]` DynamicMacAddress** _(Read)_: Does the VM Network Adapter use a
 Dynamic MAC Address.

#### Examples

* [Add multiple VM Network adapters to a VM](https://github.com/IT-Service/xITGHyperV/blob/feature/xITGHyperV/Examples/Resources/xVMNonLegacyNetworkAdapter/1-Sample_xVMNonLegacyNetworkAdapter_MultipleVM_Config.ps1)

### xVMComPort

Manages VM serial ports attached to a Hyper-V virtual machine.

#### Requirements for xVMComPort

* The Hyper-V Role has to be installed on the machine.
* The Hyper-V PowerShell module has to be installed on the machine.

#### Parameters for xVMComPort

* **`[String]` Id** _(Key)_: Unique string for identifying the resource instance.
* **`[String]` VMName** _(Required)_: Name of the VM to attach to.
* **`[UInt16]` Number** _(Required)_: serial port number.
* **`[String]` Path** _(Write)_: named pipe path or empty string.
 If this parameter is not specified, serial port detached from any named pipes.
* **`[String]` Ensure** _(Write)_: Ensures that the VM serial port is
 Present or Absent. The default value is Present. { *Present* | Absent }.
 Now supported only Present.

#### Examples

* [Attach VM serial port to a named pipe](https://github.com/IT-Service/xITGHyperV/blob/feature/xITGHyperV/Examples/Resources/xVMComPort/1-Sample_xVMComPort_Config.ps1)
