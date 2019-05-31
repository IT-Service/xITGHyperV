<#
    .SYNOPSIS
        The localized resource strings in English (en-US) for the
        resource ITG_xVMComPort.
#>

ConvertFrom-StringData @'
    GetVMComPort=Getting VM serial port information.
    FoundVMComPort=Found VM serial port.
    NoVMComPortFound=No VM serial port found.
    VMComPortExistsNoActionNeeded=VM serial port exists with requested configuration. No action needed.
    VMComPortPathIsDifferent=VM serial port exists but named pipe path is different. This will be modified.
    VMComPortDoesNotExistShouldAdd=VM serial port does not exist. It will be added.
    VMComPortExistsShouldRemove=VM serial port exists. It will be removed.
    VMComPortDoesNotExistNoActionNeeded=VM serial port does not exist. No action needed.
    VMComPortCreationDoesNotSupported=Creation of VM serial port does not supported now.
    VMComPortRemovingDoesNotSupported=Removing of VM serial port does not supported now.
'@
