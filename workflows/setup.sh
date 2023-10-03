#!/bin/bash

# Update the package manager
sudo apt update

# Install the required dependencies
sudo apt install -y git curl unzip xz-utils zip libglu1-mesa openjdk-8-jdk

# Download the latest Flutter SDK
curl -O https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_$(curl -s https://storage.googleapis.com/flutter_infra/releases/releases_linux.json | grep -oP 'version": "\K[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)-stable.tar.xz
tar xf flutter_linux_$(curl -s https://storage.googleapis.com/flutter_infra/releases/releases_linux.json | grep -oP 'version": "\K[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)-stable.tar.xz
rm flutter_linux_$(curl -s https://storage.googleapis.com/flutter_infra/releases/releases_linux.json | grep -oP 'version": "\K[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)-stable.tar.xz

# Add the Flutter SDK to the PATH
# shellcheck disable=SC2016
echo 'export PATH="$PATH:`pwd`/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# Install the Android SDK
mkdir android-sdk
cd android-sdk
curl -O https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip
unzip commandlinetools-linux-7583922_latest.zip
rm commandlinetools-linux-7583922_latest.zip
# shellcheck disable=SC2016
echo 'export ANDROID_SDK_ROOT=`pwd`' >> ~/.bashrc
source ~/.bashrc

# Install the required Android SDK components
yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3"

# Verify the installation
flutter doctor