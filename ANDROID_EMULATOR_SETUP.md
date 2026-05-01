# Android Emulator Setup Guide

This guide creates a high-fidelity Android emulator that closely mirrors a real smartphone experience.

## 1. Install required SDK packages

Run:

```bash
sdkmanager --install "platform-tools" "emulator" "cmdline-tools;latest" \
  "platforms;android-34" \
  "system-images;android-34;google_apis_playstore;x86_64"
```

If `sdkmanager` is not available, make sure you have installed Android SDK command-line tools and that `ANDROID_SDK_ROOT` points to the SDK root directory.

For additional Android versions, install these too:

```bash
sdkmanager --install \
  "platforms;android-33" \
  "system-images;android-33;google_apis_playstore;x86_64" \
  "platforms;android-32" \
  "system-images;android-32;google_apis_playstore;x86_64"
```

## 2. Create a high-fidelity AVD

Create a Pixel 8-like AVD with Play Store support:

```bash
avdmanager create avd -n "Pixel_8_API_34_Play" \
  -k "system-images;android-34;google_apis_playstore;x86_64" \
  --device "pixel_8" \
  --force
```

Optional alternate AVDs:

```bash
avdmanager create avd -n "Pixel_7_API_33_Play" \
  -k "system-images;android-33;google_apis_playstore;x86_64" \
  --device "pixel_7" \
  --force

avdmanager create avd -n "Pixel_6_API_32_Play" \
  -k "system-images;android-32;google_apis_playstore;x86_64" \
  --device "pixel_6" \
  --force
```

Or run the helper script from the repo root to create all three at once:

```bash
./create_avd.sh
```

## 3. Configure the AVD for real-device fidelity

Open the AVD config file in your home directory:

```bash
nano ~/.android/avd/Pixel_8_API_34_Play.avd/config.ini
```

Replace or merge settings with:

```ini
AvdId=Pixel_8_API_34_Play
PlayStore.enabled=yes
abi.type=x86_64
avd.ini.displayname=Pixel 8 API 34 Play
fastboot.forceColdBoot=no
hw.accelerometer=yes
hw.audioInput=yes
hw.audioOutput=yes
hw.battery=yes
hw.camera.back=webcam0
hw.camera.front=webcam1
hw.cpu.arch=x86_64
hw.cpu.ncore=host
hw.dPad=no
hw.device.manufacturer=Google
hw.device.name=pixel_8
hw.gps=yes
hw.gpu.enabled=yes
hw.gpu.mode=host
hw.initialOrientation=Portrait
hw.keyboard=no
hw.lcd.density=480
hw.mainKeys=no
hw.ramSize=6144
hw.sensors=on
hw.trackBall=no
image.sysdir.1=system-images/android-34/google_apis_playstore/x86_64/
skin.path=_no_skin
skin.name=pixel_8
sdcard.path=sdcard.img
tag.display=Google Play
tag.id=google_apis_playstore
runtime.network.latency=none
runtime.network.speed=full
disk.dataPartition.size=2048M
```

> Keep the existing `hw.device.hash2` value if it already exists.

## 4. Launch the emulator with best performance

```bash
emulator -avd Pixel_8_API_34_Play -gpu host -accel auto -no-boot-anim -memory 6144
```

## 5. Validate Google Play and native apps

After booting the emulator:

- Open `Play Store`
- Sign in with a Google account
- Confirm `Google Play Services` is available
- Install apps requiring Play Services

## 6. Use extended hardware emulation

### Location and sensors

Use emulator Extended Controls:

- `Location` to enter GPS coordinates and routes
- `Phone > Sensors` for accelerometer, gyroscope, compass, and rotation
- `Virtual sensors` to emulate motion, tilt, and device orientation

### Camera and media

Host webcam settings:

- `hw.camera.back=webcam0`
- `hw.camera.front=webcam1`

If you do not have a webcam, use `none`.

For screen recording and screenshots:

- Android Studio `Extended Controls > Screen record`
- `adb exec-out screencap -p > screen.png`

### Audio and microphone

The emulator supports host microphone and audio output.

To enable headphones or speaker routes, use the emulator audio settings and host OS sound devices.

### Bluetooth and NFC

In `config.ini`, enable:

- `hw.bluetooth=yes`
- `hw.nfc=yes`

This enables the emulator’s software Bluetooth and NFC stacks for app testing.

### Fingerprint and biometric input

Enable in `config.ini`:

- `hw.fingerprint=yes`

Then use Extended Controls to simulate fingerprint enrollment and unlock events.

### Telephony, SMS, and SIM emulation

Connect to the emulator console:

```bash
telnet localhost 5554
```

Simulate calls and messages:

```text
gsm call 1234567890
gsm sms 1234567890 "Hello from emulator"
```

Simulate signal and network state:

```text
gsm signal 4 99
gsm status home
```

### Network throttling and VPN

Launch with network options:

```bash
emulator -avd Pixel_8_API_34_Play -gpu host -accel auto -netspeed full -netdelay none
```

For slower networks:

- `-netspeed edge`
- `-netdelay gprs`
- `-netdelay lte`
- `-netdelay gsm`

Use the emulator console or Extended Controls to simulate Wi-Fi state, data roaming, and low bandwidth.

For VPN-style routing and proxy testing, use host-level tools or emulator `Proxy` settings.

### Snapshot and deployment features

Use emulator snapshots to save and restore device state quickly:

```bash
emulator -avd Pixel_8_API_34_Play -snapshot default
emulator -avd Pixel_8_API_34_Play -no-snapshot-save
```

For automation and CI environments, use:

```bash
emulator -avd Pixel_8_API_34_Play -no-window -gpu swiftshader_indirect -no-snapshot
```

## 7. More advanced emulator features

### Full device profile options

You can configure exact device metrics in `config.ini`:

- `hw.lcd.density`
- `hw.lcd.width`
- `hw.lcd.height`
- `hw.ramSize`
- `hw.cpu.ncore`

This enables realistic screen sizes, resolutions, and performance classes.

### Permissions, security, and work profiles

The emulator handles runtime permissions, lock screen security, and work profile policies just like a physical device.

For app permission testing:

- use `Settings > Apps > Permissions`
- use `adb shell pm revoke` and `adb shell pm grant`

### Debugging and profiling features

Use these tools:

- Android Studio Profiler
- `adb logcat`
- `adb shell dumpsys`
- `perfetto`
- `systrace`
- `adb shell am start` / `adb shell monkey`

### Host integration and performance tuning

Use host graphics and hardware acceleration for best performance:

- `-gpu host`
- `-accel auto`
- `hw.cpu.ncore=host`
- `hw.ramSize=6144`

If host GPU is unavailable, fallback to SwiftShader:

```bash
emulator -avd Pixel_8_API_34_Play -gpu swiftshader_indirect
```

### Custom app compatibility

Use Google Play system images to run apps requiring Play Services, and install APKs with:

```bash
adb install path/to/app.apk
```

For system-level behavior testing, use:

```bash
adb root
adb remount
```

## 8. Multi-user and work profile support

Create a second user:

```bash
adb shell pm create-user user2
```

Switch users:

```bash
adb shell am switch-user 10
```

Provision a work profile (advanced):

```bash
adb shell dpm set-device-owner com.android.managedprovisioning/.DeviceAdminReceiver
```

## 8. Debugging and profiling

Useful tools:

- `adb logcat`
- `adb shell dumpsys`
- Android Studio Profiler
- `perfetto`
- `systrace`
- `adb shell monkey`

## 9. Notes and limitations

- NFC is emulated at software level only.
- Bluetooth pairing is limited compared to a real device.
- Cellular signal is simulated rather than live.
- For absolute maximum fidelity, use this emulator alongside a physical test device.
