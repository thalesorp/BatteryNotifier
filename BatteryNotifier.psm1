$global:settings = @{}
$global:settingsFilePath = Join-Path $PSScriptRoot -ChildPath "Settings.json"
$global:settings.Title = "Battery Notifier"
$global:settings.MaxBattery = 80
$global:settings.MinBattery = 20
$global:settings.NotificationImagePath = $null

function Invoke-Notification {
    param (
        [Parameter(Mandatory=$true)][string]$message
    )

    if ($global:settings.NotificationImagePath -eq $null){
        New-BurntToastNotification -Text $global:settings.Title, $message
    } else {
        New-BurntToastNotification -AppLogo $global:settings.NotificationImagePath -Text $global:settings.Title, $message
    }
}

function Read-Settings {
    if (Test-Path -Path $global:settingsFilePath -PathType Leaf) {
        # Reading content from JSON settings file
        $settingsObject = Get-Content $global:settingsFilePath -Raw | ConvertFrom-Json
        $global:settings.MaxBattery = $settingsObject.MaxBattery
        $global:settings.MinBattery = $settingsObject.MinBattery
        $global:settings.NotificationImagePath = $settingsObject.NotificationImagePath
    } else {
        # Writing default settings on JSON settings file
        Write-Settings $global:settings.MaxBattery $global:settings.MinBattery $global:settings.NotificationImagePath
    }
}

function Write-Settings {
    param (
        [int]$maxBattery = $global:settings.MaxBattery,
        [int]$minBattery = $global:settings.MinBattery,
        [string]$imagePath = $global:settings.NotificationImagePath
    )

    $settingsObject = [PSCustomObject] @{
        MaxBattery = $maxBattery
        MinBattery = $minBattery
        NotificationImagePath = $imagePath
    }
    $settingsObject | ConvertTo-Json | Out-File $global:settingsFilePath
}

function Start-BatteryNotifier {
    # Check if battery is present
    if ($(Get-WmiObject -Class Win32_Battery) -eq $null) {
        Write-Error "Windows API error. Maybe battery isn't connected?"
        return
    }

    $lastNotifiedPercentage = 0

    while ($true) {
        Read-Settings

        $battery = Get-WmiObject -Class Win32_Battery

        switch ($battery.BatteryStatus) {

            # Discharging
            1 {
                if (($battery.EstimatedChargeRemaining -le $global:settings.MinBattery) -and ($battery.EstimatedChargeRemaining -ne $lastNotifiedPercentage)) {
                    Invoke-Notification -Message "$($battery.EstimatedChargeRemaining)%🪫"
                    $lastNotifiedPercentage = $battery.EstimatedChargeRemaining
                }
                Start-Sleep -Seconds 60
                break
            }

            # Charging
            2 {
                if (($battery.EstimatedChargeRemaining -ge $global:settings.MaxBattery) -and ($battery.EstimatedChargeRemaining -ne $lastNotifiedPercentage)) {
                    Invoke-Notification -Message "$($battery.EstimatedChargeRemaining)%🔋"
                    $lastNotifiedPercentage = $battery.EstimatedChargeRemaining
                }
                Start-Sleep -Seconds 60
                break
            }

            # Fully Charged
            3 {
                # Putting the code to sleep half of the run time expected.
                Start-Sleep -Seconds ($battery.EstimatedRunTime/2*60)
                break
            }

        }
    }
}

function Set-MinBattery {
    param (
        [Parameter(Mandatory=$true)][ValidateRange(0,100)][int]$minBattery
    )

    Write-Settings -minBattery $minBattery
}

function Set-MaxBattery {
    param (
        [Parameter(Mandatory=$true)][ValidateRange(0,100)][int]$maxBattery
    )

    Write-Settings -maxBattery $maxBattery
}

function Set-NotificationImage {
    param (
        [ValidateScript({
            $imageExtensions = @(".jpg", ".jpeg", ".png", ".gif", ".bmp", ".ico")
            $fileExtension = [System.IO.Path]::GetExtension($_).ToLower()
            if ($imageExtensions -contains $fileExtension) {
                $true
            } else {
                throw "The file '$_' is not a valid image."
            }
        })]
        [string]$imagePath
    )

    Write-Host "Set-NotificationImage = $imagePath"
    Write-Settings -NotificationImagePath $imagePath
}

Export-ModuleMember -Function Start-BatteryNotifier
Export-ModuleMember -Function Set-MinBattery
Export-ModuleMember -Function Set-MaxBattery
Export-ModuleMember -Function Set-NotificationImage
