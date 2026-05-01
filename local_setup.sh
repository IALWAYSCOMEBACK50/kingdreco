#!/usr/bin/env bash
set -euo pipefail

echo "=== Kingdreco Android Emulator Local Setup ==="
echo "This script sets up KVM and runs the Android emulator setup."
echo ""

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "Error: This setup is designed for Linux systems."
    echo "For other platforms, install Android Studio manually."
    exit 1
fi

echo "1. Installing KVM for hardware acceleration..."
sudo apt update
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

echo "2. Adding user to KVM groups..."
sudo adduser $USER kvm 2>/dev/null || true
sudo adduser $USER libvirt 2>/dev/null || true

echo "3. Setting up Android SDK..."
# Run the AVD creation script
./create_avd.sh

echo ""
echo "=== Setup Complete! ==="
echo "You may need to log out and back in for KVM permissions to take effect."
echo ""
echo "To launch the emulator:"
echo "  emulator -avd Pixel_8_API_34_Play -gpu host -accel auto -no-boot-anim -memory 6144"
echo ""
echo "To install your app:"
echo "  adb install path/to/your-app.apk"
echo ""
echo "For troubleshooting, see ANDROID_EMULATOR_SETUP.md"