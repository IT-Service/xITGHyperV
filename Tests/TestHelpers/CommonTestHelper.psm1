<#
    .SYNOPSIS
        This module should contain shared helper functions that are used by more
        than one test.
#>

<#
    .SYNOPSIS
        Returns $true if the the environment variable APPVEYOR is set to $true,
        and the environment variable CONFIGURATION is set to the value passed
        in the parameter Type.

    .PARAMETER Name
        Name of the test script that is called. Defaults to the name of the
        calling script.

    .PARAMETER Type
        Type of tests in the test file. Can be set to Unit or Integration.

    .PARAMETER Category
        Optional. One or more categories to check if they are set in
        $env:CONFIGURATION. If this are not set, the parameter Type
        is used as category.
#>
function Test-SkipContinuousIntegrationTask
{
    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name = $MyInvocation.PSCommandPath.Split('\')[-1],

        [Parameter(Mandatory = $true)]
        [ValidateSet('Unit', 'Integration')]
        [System.String]
        $Type,

        [Parameter()]
        [System.String[]]
        $Category
    )

    # Support using only the Type parameter as category names.
    if (-not $Category)
    {
        $Category = @($Type)
    }

    $result = $false

    if ($Type -eq 'Integration' -and -not $env:APPVEYOR -eq $true)
    {
        Write-Warning -Message ('{1} test for {0} will be skipped unless $env:APPVEYOR is set to $true' -f $Name, $Type)
        $result = $true
    }

    if ($env:APPVEYOR -eq $true -and $env:CONFIGURATION -notin $Category)
    {
        Write-Verbose -Message ('{1} tests in {0} will be skipped unless $env:CONFIGURATION is set to ''{1}''.' -f $Name, ($Category -join ''', or ''')) -Verbose
        $result = $true
    }

    return $result
}

<#
    .SYNOPSIS
        Returns $true if the the environment variable APPVEYOR is set to $true,
        and the environment variable CONFIGURATION is set to the value passed
        in the parameter Type.

    .PARAMETER Category
        One or more categories to check if they are set in $env:CONFIGURATION.
#>
function Test-ContinuousIntegrationTaskCategory
{
    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String[]]
        $Category
    )

    $result = $false

    if ($env:APPVEYOR -eq $true -and $env:CONFIGURATION -in $Category)
    {
        $result = $true
    }

    return $result
}

<#
    .SYNOPSIS
        Tests if Hyper-V is installed on this OS.

    .OUTPUTS
        True if Hyper-V is installed. False otherwise.
#>
function Test-HyperVInstalled
{
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
    )

    # Ensure that the tests can be performed on this computer
    if ($PSVersionTable.PSEdition -eq 'Core')
    {
        # Nano Server uses Get-WindowsOptionalFeature like Desktop OS
        $ProductType = 1
    }
    else
    {
        $ProductType = (Get-CimInstance Win32_OperatingSystem).ProductType
    } # if
    switch ($ProductType)
    {
        1
        {
            # Desktop OS or Nano Server
            $HyperVInstalled = (((Get-WindowsOptionalFeature `
                            -FeatureName Microsoft-Hyper-V `
                            -Online).State -eq 'Enabled') -and `
                ((Get-WindowsOptionalFeature `
                            -FeatureName Microsoft-Hyper-V-Management-PowerShell `
                            -Online).State -eq 'Enabled'))
            Break
        }
        3
        {
            # Server OS
            $HyperVInstalled = (((Get-WindowsFeature -Name Hyper-V).Installed) -and `
                ((Get-WindowsFeature -Name Hyper-V-PowerShell).Installed))
            Break
        }
        default
        {
            # Unsupported OS type for testing
            Write-Verbose -Message "Integration tests cannot be run on this operating system." -Verbose
            Break
        }
    }

    if ($HyperVInstalled -eq $false)
    {
        Write-Verbose -Message "Integration tests cannot be run because Hyper-V Components not installed." -Verbose
        Return $false
    }
    Return $True
}
