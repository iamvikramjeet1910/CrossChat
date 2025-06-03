#
//  buildAndRunMultipleSimulators.sh
//  CrossChat
//
//  Created by Vikram Kumar on 03/06/25

#!/bin/bash

# Description: Script to build once and run app on multiple simulators
# Run on terminal: /bin/sh buildAndRunMultipleSimulators.sh (uncomment all UDIDs on simulators section of this script)
# Author: Rob Enriquez
# Last Update: 8/31/2024

# Example project
# project name = SwiftUI-WeatherApp
# app name = SwiftUI-WeatherApp
# scheme = SwiftUI-WeatherApp
# bundle identifier = com.robe.games.ios.SwiftUI-WeatherApp

# Define your project and scheme
project_name="CrossChat"
scheme="CrossChat"
app_name="CrossChat"
bundle_identifier="chhotu123kota-gmail.com.CrossChat"
sdk="iphonesimulator"
configuration="Debug"
project_path="$(dirname "$0")/${app_name}.xcodeproj"  # Relative path to the Xcode project

# Define simulators
# open Run Destinations in Xcode Cmd+Shift+2 to check the device name and identifier
# or in terminal: xcrun simctl list devices

simulators=(
    # Using device name
    "iPhone 16 pro"
    "iPhone 16 pro max"
    # "iPhone 15" (comment if running on Xcode, otherwise uncomment to use on CLI)

    # Using device identifier
     "C014F525-B23C-40E9-B8E6-5204E2D1B84B"  # iPad Pro M4 13 inch
     "F98A56E4-8CF1-4204-955A-1D241A7D08A8"  # iPad Mini 6th gen
    # "B9B91B7C-D1C1-490F-BF70-2B089A5A82EC"  # iPhone 15 (comment if running on Xcode, otherwise uncomment to use on CLI)

)

# Build the Xcode project
echo "Building the Xcode project..."
xcodebuild -project "$project_path" -scheme "$scheme" -sdk "$sdk" -configuration "$configuration" build

# Find the .app file
app_path=$(find ~/Library/Developer/Xcode/DerivedData/${project_name}-*/Build/Products/Debug-iphonesimulator -name "${app_name}.app" | head -n 1)

if [ -z "$app_path" ]; then
    echo "Error: .app file not found."
    exit 1
fi

echo "App found at: $app_path"

# Install and launch the app on each simulator
for simulator in "${simulators[@]}"; do
    # Check if the simulator is already booted
    if ! xcrun simctl list booted | grep -q "$simulator"; then
        echo "Booting simulator $simulator..."
        xcrun simctl boot "$simulator"
    else
        echo "Simulator $simulator is already booted."
    fi

    echo "Installing app on simulator $simulator..."
    xcrun simctl install "$simulator" "$app_path"

    echo "Launching app on simulator $simulator..."
    xcrun simctl launch "$simulator" "$bundle_identifier"
done

echo "All operations completed."
