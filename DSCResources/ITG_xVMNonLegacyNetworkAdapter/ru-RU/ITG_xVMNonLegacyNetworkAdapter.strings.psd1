<#
    .SYNOPSIS
        Локализованные ресурсы на русском языке (ru-RU)
        для ITG_xVMNonLegacyNetworkAdapter.
#>

ConvertFrom-StringData @'
    VMNameAndManagementTogether=VMName не может быть указана, если установлен флаг ManagementOS.
    MustProvideVMName=Должно быть указано имя виртуальной машины VMName, если флаг ManagementOS не установлен.
    GetVMNetAdapter=Получение информации о современных сетевых адаптерах.
    FoundVMNetAdapter=Найдены современные сетевые адаптеры.
    NoVMNetAdapterFound=Не найдены современные сетевые адаптеры.
    StaticMacAddressChosen=Статический MAC адрес указан.
    StaticAddressDoesNotMatch=Статический MAC адрес на современном сетевом адаптере не соответствует указанному.
    ModifyVMNetAdapter=Современный сетевой адаптер присутствует с конфигурацией, отличной от указанной. Конфигурация будет модифицирована.
    EnableDynamicMacAddress=Современный сетевой адаптер присутствует, но без динамического MAC адреса.
    EnableStaticMacAddress=Современный сетевой адаптер присутствует, но без статического MAC адреса.
    PerformVMNetModify=Изменение конфигурации современного сетевого адаптера.
    CannotChangeHostAdapterMacAddress=Современный сетевой адаптер - это адаптер Hyper-V хоста. Его конфигурация не может быть изменена.
    VMNetAdapterExistsNoActionNeeded=Современный сетевой адаптер присутствует с требуемой конфигурацией. Дополнительных действий не требуется.
    VMNetAdapterDoesNotExistShouldAdd=Современный сетевой адаптер отсутствует. Он будет добавлен.
    VMNetAdapterExistsShouldRemove=Современный сетевой адаптер присутствует. Он будет удалён.
    VMNetAdapterDoesNotExistNoActionNeeded=Современный сетевой адаптер отсутствует. Дополнительных действий не требуется.
    StaticMacExists=Статический Mac адрес соответствует указанному.
    SwitchIsDifferent=Современный сетевой адаптер не подключен к указанному коммутатору.
'@
