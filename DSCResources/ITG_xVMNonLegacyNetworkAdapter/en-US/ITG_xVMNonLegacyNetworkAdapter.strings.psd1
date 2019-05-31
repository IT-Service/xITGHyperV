<#
    .SYNOPSIS
        The localized resource strings in English (en-US) for the
        resource ITG_xVMNonLegacyNetworkAdapter.
#>

ConvertFrom-StringData @'
    VMNameAndManagementTogether=VMName cannot be provided when ManagementOS is set to True.
    MustProvideVMName=Must provide VMName parameter when ManagementOS is set to False.
    GetVMNetAdapter=Getting VM Non Legacy Network Adapter information.
    FoundVMNetAdapter=Found VM Non Legacy Network Adapter.
    NoVMNetAdapterFound=No VM Non Legacy Network Adapter found.
    StaticMacAddressChosen=Static MAC Address has been specified.
    StaticAddressDoesNotMatch=Staic MAC address on the VM Non Legacy Network Adapter does not match.
    ModifyVMNetAdapter=VM Non Legacy Network Adapter exists with different configuration. This will be modified.
    EnableDynamicMacAddress=VM Non Legacy Network Adapter exists but without Dynamic MAC address setting.
    EnableStaticMacAddress=VM Non Legacy Network Adapter exists but without static MAC address setting.
    PerformVMNetModify=Performing VM Non Legacy Network Adapter configuration changes.
    CannotChangeHostAdapterMacAddress=VM Non Legacy Network adapter in configuration is a host adapter. Its configuration cannot be modified.
    VMNetAdapterExistsNoActionNeeded=VM Non Legacy Network Adapter exists with requested configuration. No action needed.
    VMNetAdapterDoesNotExistShouldAdd=VM Non Legacy Network Adapter does not exist. It will be added.
    VMNetAdapterExistsShouldRemove=VM Non Legacy Network Adapter exists. It will be removed.
    VMNetAdapterDoesNotExistNoActionNeeded=VM Non Legacy Network adapter does not exist. No action needed.
    StaticMacExists=StaicMacAddress configuration exists as desired.
    SwitchIsDifferent=Legacy Non Network Adapter is not connected to the requested switch.
'@
