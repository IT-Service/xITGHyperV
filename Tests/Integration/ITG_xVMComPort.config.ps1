#region HEADER
# Integration Test Config Template Version: 1.2.0
#endregion

$configFile = [System.IO.Path]::ChangeExtension($MyInvocation.MyCommand.Path, 'json')
if (Test-Path -Path $configFile)
{
    <#
        Allows reading the configuration data from a JSON file, for real testing
        scenarios outside of the CI.
    #>
    $ConfigurationData = Get-Content -Path $configFile | ConvertFrom-Json
}
else
{
    $ConfigurationData = @{
        AllNodes = @(
            @{
                NodeName = 'localhost'
                VMName = 'HyperVIntTestsVM'
                Number = 1
                Path = '\\.\pipe\testpipe22'
            }
        )
    }
}

Configuration ITG_xVMComPort_Create_Config
{
    Import-DscResource -ModuleName 'xITGHyperV'

    node $AllNodes.NodeName
    {
        xVMComPort 'Integration_Test'
        {
            VMName = $Node.VMName
            Number = $Node.Number
            Path = $Node.Path
            Ensure = 'Present'
        }

    }
}

Configuration ITG_xVMComPort_Remove_Config
{
    Import-DscResource -ModuleName 'xITGHyperV'

    node $AllNodes.NodeName
    {
        xVMComPort 'Integration_Test'
        {
            VMName = $Node.VMName
            Number = $Node.Number
            Path = ''
            Ensure = 'Present'
        }

    }
}
