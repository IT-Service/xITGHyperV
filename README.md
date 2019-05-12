# xITGHyperV

The **xITGHyperV** module based on xHyper-V and contains DSC resources for
 deployment and configuration of virtual machines and related resources.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/).

## Branches

### master

[![Build status](https://ci.appveyor.com/api/projects/status/q0dap46majxqxc3q/branch/master?svg=true)](https://ci.appveyor.com/project/IT-Service/xITGHyperV/branch/master)
[![codecov](https://codecov.io/gh/IT-Service/xITGHyperV/branch/master/graph/badge.svg)](https://codecov.io/gh/IT-Service/xITGHyperV/branch/master)

This is the branch containing the latest release - no contributions should be
made directly to this branch.

### develop

[![Build status](https://ci.appveyor.com/api/projects/status/q0dap46majxqxc3q/branch/develop?svg=true)](https://ci.appveyor.com/project/IT-Service/xITGHyperV/branch/develop)
[![codecov](https://codecov.io/gh/PowerShell/xHyper-V/branch/develop/graph/badge.svg)](https://codecov.io/gh/IT-Service/xITGHyperV/branch/develop)

This is the development branch to which contributions should be proposed by
contributors as pull requests. This development branch will periodically be
merged to the master branch, and be released to [PowerShell Gallery](https://www.powershellgallery.com/).

## Contributing

Please check out common DSC Resources [contributing guidelines](CONTRIBUTING.md).

## Change log

A full list of changes in each version can be found in the [change log](CHANGELOG.md).

## Resources

* [**xVMLegacyNetworkAdapter**](#xvmlegacynetworkadapter) manages legacy
 VMNetadapters attached to a Hyper-V virtual machine.

### xVMLegacyNetworkAdapter

Manages legacy VMNetadapters attached to a Hyper-V virtual machine.

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

* [Add multiple VM Network adapters to a VM](https://github.com/IT-Service/xITGHyperV/blob/feature/xITGHyperV/Examples/Resources/xVMLegacyNetworkAdapter/1-Sample_xVMLegacyNetworkAdapter_MultipleVM_Config.ps1)
