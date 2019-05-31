<#
    .SYNOPSIS
        The localized resource strings in English (en-US) for the
        resource ITG_xVMLegacyNetworkAdapter.
#>

ConvertFrom-StringData @'
    VMNameAndManagementTogether=VMName cannot be provided when ManagementOS is set to True.
    MustProvideVMName=Must provide VMName parameter when ManagementOS is set to False.
    GetVMNetAdapter=Getting VM Legacy Network Adapter information.
    FoundVMNetAdapter=Found VM Legacy Network Adapter.
    NoVMNetAdapterFound=No VM Legacy Network Adapter found.
    StaticMacAddressChosen=Static MAC Address has been specified.
    StaticAddressDoesNotMatch=Staic MAC address on the VM Legacy Network Adapter does not match.
    ModifyVMNetAdapter=VM Legacy Network Adapter exists with different configuration. This will be modified.
    EnableDynamicMacAddress=VM Legacy Network Adapter exists but without Dynamic MAC address setting.
    EnableStaticMacAddress=VM Legacy Network Adapter exists but without static MAC address setting.
    PerformVMNetModify=Performing VM Legacy Network Adapter configuration changes.
    CannotChangeHostAdapterMacAddress=VM Legacy Network adapter in configuration is a host adapter. Its configuration cannot be modified.
    VMNetAdapterExistsNoActionNeeded=VM Legacy Network Adapter exists with requested configuration. No action needed.
    VMNetAdapterDoesNotExistShouldAdd=VM Legacy Network Adapter does not exist. It will be added.
    VMNetAdapterExistsShouldRemove=VM Legacy Network Adapter exists. It will be removed.
    VMNetAdapterDoesNotExistNoActionNeeded=VM Legacy Network adapter does not exist. No action needed.
    StaticMacExists=StaicMacAddress configuration exists as desired.
    SwitchIsDifferent=Legacy Network Adapter is not connected to the requested switch.
'@
