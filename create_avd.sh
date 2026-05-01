#!/usr/bin/env bash
set -euo pipefail

# Create a high-fidelity Android emulator AVD with Google Play support.

ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}
PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$PATH"

if ! command -v sdkmanager >/dev/null 2>&1; then
  echo "Error: sdkmanager not found."
  echo "Install Android SDK command-line tools and ensure ANDROID_SDK_ROOT is correct."
  echo "If using a local SDK install, set ANDROID_SDK_ROOT and retry."
  exit 1
fi

if ! command -v avdmanager >/dev/null 2>&1; then
  echo "Error: avdmanager not found."
  echo "Install Android SDK command-line tools and ensure ANDROID_SDK_ROOT is correct."
  exit 1
fi

sdkmanager --install "platform-tools" "emulator" "cmdline-tools;latest" \
  "platforms;android-34" \
  "system-images;android-34;google_apis_playstore;x86_64" \
  "platforms;android-33" \
  "system-images;android-33;google_apis_playstore;x86_64" \
  "platforms;android-32" \
  "system-images;android-32;google_apis_playstore;x86_64"

avdmanager create avd -n "Pixel_8_API_34_Play" \
  -k "system-images;android-34;google_apis_playstore;x86_64" \
  --device "pixel_8" \
  --force

avdmanager create avd -n "Pixel_7_API_33_Play" \
  -k "system-images;android-33;google_apis_playstore;x86_64" \
  --device "pixel_7" \
  --force

avdmanager create avd -n "Pixel_6_API_32_Play" \
  -k "system-images;android-32;google_apis_playstore;x86_64" \
  --device "pixel_6" \
  --force

cat <<'EOF' > "$HOME/.android/avd/Pixel_8_API_34_Play.avd/config.ini"
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
hw.keyboard=yes
hw.lcd.density=480
hw.mainKeys=no
hw.nfc=yes
hw.bluetooth=yes
hw.fingerprint=yes
hw.multiTouch=yes
hw.ramSize=6144
hw.sensors=on
hw.sdCard=yes
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
EOF

echo "AVDs Pixel_8_API_34_Play, Pixel_7_API_33_Play, and Pixel_6_API_32_Play created."
echo "Launch one with: emulator -avd Pixel_8_API_34_Play -gpu host -accel auto -no-boot-anim -memory 6144"
