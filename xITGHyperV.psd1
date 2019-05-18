@{
    # RootModule = ''

    # CompatiblePSEditions = @()

    # Version number of this module.
    ModuleVersion      = '1.1.1.80'

    # ID used to uniquely identify this module
    GUID               = '274a6c3f-5633-4487-aed1-e4130db26a51'

    # Author of this module
    Author             = 'Sergei S. Betke'

    # Company or vendor of this module
    CompanyName        = 'Test-St-Petersburg'

    # Copyright statement for this module
    Copyright          = '(c) 2019 Sergey S. Betke. All rights reserved.'

    # Description of the functionality provided by this module
    Description        = 'DSC resources xITGHyperV module.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion  = '4.0'

    # PowerShellHostName = ''
    # PowerShellHostVersion = ''

    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module
    CLRVersion         = '4.0'

    # ScriptsToProcess = @()

    # TypesToProcess = @()

    # FormatsToProcess = @()

    # NestedModules = @()

    # Functions to export from this module
    FunctionsToExport  = '*'

    # Cmdlets to export from this module
    CmdletsToExport    = '*'

    # ProcessorArchitecture = ''

    RequiredAssemblies = @()

    #RequiredModules    = @(
    #    @{ ModuleName = 'xHyper-V'; ModuleVersion = '3.16.0.0' }
    #)

    VariablesToExport  = @()

    AliasesToExport    = @()

    # DscResourcesToExport = @()

    # ModuleList = @()

    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData        = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags                       = @('DesiredStateConfiguration', 'DSC', 'DSCResource', 'HyperV')

            # A URL to the license for this module.
            LicenseUri                 = 'https://github.com/IT-Service/xITGHyperV/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri                 = 'https://github.com/IT-Service/xITGHyperV'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes               = @'
## Bug fixes
- Fix readme.md (xVMComPort Number property type)

'@

            # Prerelease string of this module
            # Prerelease = ''

            RequireLicenseAcceptance   = $false

            # External dependent modules of this module
            ExternalModuleDependencies = @(
                @{ ModuleName = 'xHyper-V'; ModuleVersion = '3.16.0.0' }
            )

        } # End of PSData hash table

    } # End of PrivateData hash table

    # HelpInfoURI = ''

    # DefaultCommandPrefix = ''
}
