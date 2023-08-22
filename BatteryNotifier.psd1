@{
    RootModule = 'BatteryNotifier.psm1'
    ModuleVersion = '0.1.0'
    Author = 'Thales Pinto <ThalesORP@protonmail.com>'
    Copyright = '(c) 2023 Thales Pinto under the MIT license;'
    Description = 'Send a notification to disconnect the laptop when the battery reaches a certain threshold, thereby optimizing the lifespan of the battery'
    FunctionsToExport = @('Start-BatteryNotifier', 'Set-MinBattery', 'Set-MaxBattery')
    CmdletsToExport = @()
    AliasesToExport = @()
    RequiredModules = @("BurntToast")
    PrivateData = @{
        PSData = @{
            LicenseUri = 'https://github.com/thalesorp/BatteryNotifier/blob/main/LICENSE'
            ProjectUri = 'https://github.com/thalesorp/BatteryNotifier'
        }
    }
}
