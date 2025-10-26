#!/bin/bash
set -e

# ChromeOS EC Tool - Debian Package Build Script
# This script builds a .deb package for ectool

echo "================================"
echo "Building ectool Debian package"
echo "================================"
echo ""

# Check if we're in the right directory
if [ ! -f "CMakeLists.txt" ]; then
    echo "Error: This script must be run from the ectool source directory"
    exit 1
fi

# Check for required build dependencies
echo "Checking build dependencies..."
MISSING_DEPS=""

for dep in dpkg-buildpackage cmake pkg-config; do
    if ! command -v $dep &> /dev/null; then
        MISSING_DEPS="$MISSING_DEPS $dep"
    fi
done

# Check for debhelper (dh command)
if ! command -v dh &> /dev/null; then
    MISSING_DEPS="$MISSING_DEPS debhelper"
fi

# Check for development libraries
if ! pkg-config --exists libusb-1.0; then
    MISSING_DEPS="$MISSING_DEPS libusb-1.0-0-dev"
fi

if ! pkg-config --exists libftdi1; then
    MISSING_DEPS="$MISSING_DEPS libftdi1-dev"
fi

if [ -n "$MISSING_DEPS" ]; then
    echo ""
    echo "Error: Missing required dependencies:$MISSING_DEPS"
    echo ""
    echo "Install them with:"
    echo "  sudo apt install debhelper devscripts cmake pkg-config libusb-1.0-0-dev libftdi1-dev build-essential"
    exit 1
fi

echo "All dependencies found."
echo ""

# Clean previous build artifacts
echo "Cleaning previous build artifacts..."
rm -rf debian/.debhelper debian/ectool debian/*.log debian/*.substvars debian/files
rm -f ../ectool_*.deb ../ectool_*.changes ../ectool_*.buildinfo ../ectool_*.dsc ../ectool_*.tar.xz

# Build the package
echo "Building Debian package..."
echo ""

dpkg-buildpackage -us -uc -b

# Check if build was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "================================"
    echo "Build completed successfully!"
    echo "================================"
    echo ""
    echo "Package files created in parent directory:"
    ls -lh ../ectool_*.deb 2>/dev/null || echo "No .deb files found"
    echo ""
    echo "To install the package, run:"
    echo "  sudo dpkg -i ../ectool_*.deb"
    echo ""
    echo "To install dependencies if needed:"
    echo "  sudo apt install -f"
else
    echo ""
    echo "Build failed!"
    exit 1
fi
