# Battery Notifier

The **Battery Notifier** is a simple utility that provides real-time notifications about your laptop's battery status. It allows you to set minimum and maximum battery levels, and it will notify you when your battery charge falls below the minimum or exceeds the maximum level.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Functions](#functions)
- [Contributing](#contributing)
- [License](#license)

## Installation

1. Download or clone this repository to your local machine.

2. Open a PowerShell console with administrator privileges.

3. Navigate to the directory where you have downloaded/cloned this repository.

4. Run the following command to import the module:

   ```powershell
   Import-Module .\BatteryNotifier.psm1
   ```

## Usage

To start receiving battery notifications, use the `Start-BatteryNotifier` function. It will continuously monitor your laptop's battery status and display notifications when the battery reaches your defined minimum and maximum levels.

```powershell
Start-BatteryNotifier
```

You can customize the minimum and maximum battery levels as well as the notification image using the provided functions (see [Configuration](#configuration)).

## Configuration

The Battery Notifier module uses a JSON settings file to store configuration information. If the settings file does not exist, default values will be used.

- `MaxBattery`: The maximum battery charge percentage at which you want to be notified (default: 80).
- `MinBattery`: The minimum battery charge percentage at which you want to be notified (default: 20).
- `NotificationImagePath`: The path to a custom notification image (default: null).

To configure these settings, use the following functions:

- `Set-MaxBattery`: Set the maximum battery charge percentage for notifications.
- `Set-MinBattery`: Set the minimum battery charge percentage for notifications.
- `Set-NotificationImage`: Set a custom notification image.

Example:

```powershell
# Set the maximum battery level to 90%
Set-MaxBattery -maxBattery 90

# Set the minimum battery level to 10%
Set-MinBattery -minBattery 10

# Set a custom notification image
Set-NotificationImage -notificationImagePath "C:\path\to\image.jpg"
```

## Functions

### Start-BatteryNotifier

Starts monitoring the laptop's battery status and displays notifications based on the configured minimum and maximum battery levels.

### Set-MinBattery

Sets the minimum battery charge percentage for notifications. Takes an integer value between 0 and 100 as input.

```powershell
Set-MinBattery -minBattery 15
```

### Set-MaxBattery

Sets the maximum battery charge percentage for notifications. Takes an integer value between 0 and 100 as input.

```powershell
Set-MaxBattery -maxBattery 85
```

### Set-NotificationImage

Sets a custom notification image. Takes a valid image file path (JPG, JPEG, PNG, GIF, BMP, ICO) as input.

```powershell
Set-NotificationImage -notificationImagePath "C:\path\to\image.jpg"
```

## Contributing

Contributions to this project are welcome! If you find any issues or have suggestions for improvements, please open an issue or create a pull request.

## License

This project is licensed under the [MIT License](LICENSE). Feel free to use, modify, and distribute it according to the terms of the license.
