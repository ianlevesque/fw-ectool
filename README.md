# ectool for Framework Laptops

**Control your Framework Laptop's fan speed and EC settings from the command line.**

This tool allows you to manually control fan speeds, monitor temperatures, check battery status, and interact with your Framework Laptop's embedded controller (EC). Perfect for users who want fine-grained control over their laptop's cooling and power management.

---

This is a fork of [DHowett's ectool](https://gitlab.howett.net/DHowett/ectool) that adds Debian/Ubuntu package builds and automated releases.

## What is ectool?

`ectool` is a command-line utility for communicating with ChromeOS embedded controllers (EC). It allows you to query and control various EC features including:

- **Fan control** (speed, duty cycle, automatic control)
- Battery information
- Temperature sensors
- Keyboard backlight
- Power management
- And many other EC-related functions

This tool is particularly useful for Framework Laptops and other devices that use ChromeOS-compatible embedded controllers.

## Installation

### Install from Debian Package (Recommended)

Download the latest `.deb` package from the [Releases](../../releases) page and install:

```bash
sudo dpkg -i ectool_*.deb
sudo apt install -f  # Install any missing dependencies if needed
```

### Build from Source

#### Prerequisites

```bash
sudo apt update
sudo apt install cmake libusb-1.0-0-dev libftdi1-dev build-essential
```

#### Build

```bash
mkdir -p build
cd build
cmake ..
make
```

The binary will be available at `build/src/ectool`.

#### Build Debian Package

A build script is provided to create a Debian package:

```bash
./build-deb.sh
```

The `.deb` file will be created in the parent directory.

## Usage Examples

### Fan Control Commands

```bash
# Check number of fans
ectool pwmgetnumfans

# Get current fan RPM
ectool pwmgetfanrpm all

# Set manual fan duty cycle to 50%
ectool fanduty 50

# Re-enable automatic fan control
ectool autofanctrl 1

# Set target fan RPM
ectool pwmsetfanrpm 3000
```

### Other Useful Commands

```bash
# Display all available commands
ectool help

# Get battery information
ectool battery

# Check temperatures
ectool temps all

# Get EC version
ectool version
```

## What's Different from Upstream?

This fork adds:

- Debian packaging files (`debian/` directory)
- Build script for creating Debian packages (`build-deb.sh`)
- GitHub Actions workflow for automated builds and releases
- CMake install target for proper package installation

## Upstream Information

This repository was originally extracted from the ChromeOS EC repository using [git-filter-repo](https://github.com/newren/git-filter-repo). The base fork is maintained by [DHowett at GitLab](https://gitlab.howett.net/DHowett/ectool).

### Original Files Extracted

The following files were extracted from the ChromeOS EC repository:

```
glob:util/comm-*.cc
glob:util/comm-*.h
util/ectool.cc
util/ectool.h
util/ectool_keyscan.cc
util/ec_flash.cc
util/ec_flash.h
util/ec_panicinfo.cc
util/ec_panicinfo.h
util/ectool_i2c.cc
util/cros_ec_dev.h
util/misc_util.cc
util/misc_util.h
util/lock/file_lock.cc
util/lock/file_lock.h
util/lock/gec_lock.cc
util/lock/gec_lock.h
util/lock/ipc_lock.h
util/lock/locks.h
common/crc.c

util/ ==> src/
common/crc.c ==> src/crc.cc

include/battery.h
include/ec_commands.h
(and other header files...)
```

## Requirements

- Ubuntu 20.04 or later / Debian 10 or later
- libusb-1.0-0
- libftdi1-2

## License

This project inherits the MIT license from the ChromeOS EC repository.

## Contributing

Issues and pull requests are welcome. For major changes related to the Debian packaging, please open an issue first.

For issues with the core ectool functionality, consider reporting to the [upstream repository](https://gitlab.howett.net/DHowett/ectool).
