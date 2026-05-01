# Kingdreco Android Emulator Setup

This repository contains a high-fidelity Android emulator setup that closely mirrors real smartphone behavior, including Google Play Store support and advanced hardware emulation.

## Quick Start (Local Linux Machine)

1. **Clone this repository:**
   ```bash
   git clone https://github.com/IALWAYSCOMEBACK50/kingdreco.git
   cd kingdreco
   ```

2. **Run the automated setup:**
   ```bash
   ./local_setup.sh
   ```
   This will install KVM, Android SDK, and create optimized AVDs.

3. **Launch the emulator:**
   ```bash
   emulator -avd Pixel_8_API_34_Play -gpu host -accel auto -no-boot-anim -memory 6144
   ```

4. **Install your app:**
   ```bash
   adb install path/to/your-app.apk
   ```

## Manual Setup

If you prefer manual setup, see [ANDROID_EMULATOR_SETUP.md](ANDROID_EMULATOR_SETUP.md) for detailed instructions.

## Features

- Google Play Store integration
- Hardware acceleration (GPS, sensors, NFC, Bluetooth)
- High-performance configuration
- Multiple Android versions (API 32-34)
- Optimized for development and testing

## Requirements

- Linux with KVM support
- 8GB+ RAM recommended
- Hardware virtualization enabled in BIOS

## Troubleshooting

If the emulator fails to start:
1. Ensure KVM is enabled: `ls /dev/kvm`
2. Check user permissions: `groups | grep kvm`
3. Try software rendering: `emulator -avd Pixel_8_API_34_Play -gpu swiftshader_indirect`

For more help, see the full guide in `ANDROID_EMULATOR_SETUP.md`.