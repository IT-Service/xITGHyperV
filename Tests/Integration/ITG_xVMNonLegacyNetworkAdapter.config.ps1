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

                VMLegacyNICName = 'LegacyNIC'
                SwitchName = 'Switch01'
                VMName = 'HyperVIntTestsVM'
            }
        )
    }
}

Configuration ITG_xVMNonLegacyNetworkAdapter_Create_Config
{
    Import-DscResource -ModuleName 'xITGHyperV'

    node $AllNodes.NodeName
    {
        xVMNonLegacyNetworkAdapter 'Integration_Test'
        {
            Id = $Node.VMLegacyNICName
            Name = $Node.VMLegacyNICName
            SwitchName = $Node.SwitchName
            VMName = $Node.VMName
            Ensure = 'Present'
        }

    }
}

Configuration ITG_xVMNonLegacyNetworkAdapter_Remove_Config
{
    Import-DscResource -ModuleName 'xITGHyperV'

    node $AllNodes.NodeName
    {
        xVMNonLegacyNetworkAdapter 'Integration_Test'
        {
            Id = $Node.VMLegacyNICName
            Name = $Node.VMLegacyNICName
            SwitchName = $Node.SwitchName
            VMName = $Node.VMName
            Ensure = 'Absent'
        }

    }
}
