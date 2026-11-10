# JetHub Recovery System

Recovery environment for restoring and reinstalling firmware on JetHome JetHub devices.

## Supported devices

- JetHub J310
- JetHub J100 (D1)

## Recovery application

[jrescue-app](https://github.com/jethome-iot/jrescue-app) provides the recovery
interface. Use it to:

- Configure Ethernet and Wi-Fi connections.
- Download firmware and install it on the device.
- View device status and recovery progress.

The application offers web and console interfaces. On devices with an OLED
display, it also provides a local interface for recovery controls and status.

## Build

Requires Docker and Git. Run the build from the repository root.

For J310:

```sh
./buildroot.sh jethub_j310
```

For J100:

```sh
./buildroot.sh jethub_j100
```

The recovery image is saved to `output/images/recovery.fit`.
