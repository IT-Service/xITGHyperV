<#
    .SYNOPSIS
        Локализованные ресурсы на русском языке (ru-RU)
        для ITG_xVMLegacyNetworkAdapter.
#>

ConvertFrom-StringData @'
	VMNameAndManagementTogether=VMName не может быть указан, если установлен флаг ManagementOS.
	MustProvideVMName=Должно быть указано имя виртуальной машины VMName, если флаг ManagementOS не установлен.
	GetVMNetAdapter=Получение информации об устаревших сетевых адаптерах.
	FoundVMNetAdapter=Найдены устаревшие сетевые адаптеры.
	NoVMNetAdapterFound=Не найдены устаревшие сетевые адаптеры.
	StaticMacAddressChosen=Статический MAC адрес указан.
	StaticAddressDoesNotMatch=Статический MAC адрес на устаревшем сетевом адаптере не соответствует указанному.
	ModifyVMNetAdapter=Устаревший сетевой адаптер присутствует с конфигурацией, отличной от указанной. Конфигурация будет модифицирована.
	EnableDynamicMacAddress=Устаревший сетевой адаптер присутствует, но без динамического MAC адреса.
	EnableStaticMacAddress=Устаревший сетевой адаптер присутствует, но без статического MAC адреса.
	PerformVMNetModify=Изменение конфигурации устаревшего сетевого адаптера.
	CannotChangeHostAdapterMacAddress=Устаревший сетевой адаптер - это адаптер Hyper-V хоста. Его конфигурация не может быть изменена.
	VMNetAdapterExistsNoActionNeeded=Устаревший сетевой адаптер присутствует с требуемой конфигурацией. Дополнительных действий не требуется.
	VMNetAdapterDoesNotExistShouldAdd=Устаревший сетевой адаптер отсутствует. Он будет добавлен.
	VMNetAdapterExistsShouldRemove=Устаревший сетевой адаптер присутствует. Он будет удалён.
	VMNetAdapterDoesNotExistNoActionNeeded=Устаревший сетевой адаптер отсутствует. Дополнительных действий не требуется.
	StaticMacExists=Статический Mac адрес соответствует указанному.
	SwitchIsDifferent=Устаревший сетевой адаптер не подключен к указанному коммутатору.
'@
