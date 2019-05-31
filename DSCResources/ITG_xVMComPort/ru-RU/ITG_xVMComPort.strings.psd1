<#
    .SYNOPSIS
        Локализованные ресурсы на русском языке (ru-RU)
        для ITG_xVMComPort.
#>

ConvertFrom-StringData @'
    GetVMComPort=Получение информации о последовательных портах виртуальных машин.
    FoundVMComPort=Найдены последовательные порты.
    NoVMComPortFound=Последовательные порты не найдены.
    VMComPortExistsNoActionNeeded=Последовательный порт присутствует с требуемой конфигурацией. Дополнительных действий не требуется.
    VMComPortPathIsDifferent=Последовательный порт присутствует, но путь именованного канала отличается. Он будет исправлен.
    VMComPortDoesNotExistShouldAdd=Последовательный порт отсутствует. Он будет добавлен.
    VMComPortExistsShouldRemove=Последовательный порт присутствует. Он будет удалён.
    VMComPortDoesNotExistNoActionNeeded=Последовательный порт отсутствует. Дополнительных действий не требуется.
    VMComPortCreationDoesNotSupported=Добавление последовательных портов в настоящее время не поддерживается.
    VMComPortRemovingDoesNotSupported=Удаление последовательных портов в настоящее время не поддерживается.
'@
