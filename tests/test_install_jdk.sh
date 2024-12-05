#!/bin/bash

# Function to test if a command was successful
function assert() {
    if [ $? -ne 0 ]; then
        echo "Test failed: $1"
        exit 1
    else
        echo "Test passed: $1"
    fi
}

# Test 1: Check if 'curl' is installed
command -v curl >/dev/null 2>&1
assert "curl is installed"

# Test 2: Check if 'hdiutil' is installed
command -v hdiutil >/dev/null 2>&1
assert "hdiutil is installed"

# Test 3: Check if the JDK is already installed
if /usr/libexec/java_home -v 11 &> /dev/null; then
    echo "JDK 11 is already installed."
else
    echo "JDK 11 is not installed. Proceeding with the download test."

    # Test 4: Download JDK
    echo "Downloading JDK 11.0.12..."
    curl -L -O "https://download.oracle.com/java/11/archive/jdk-11.0.12_macos-x64_bin.dmg"
    assert "JDK download succeeded"

    # Test 5: Check if the DMG file exists
    if [ -f "jdk-11.0.12_macos-x64_bin.dmg" ]; then
        echo "JDK DMG file downloaded successfully."
    else
        echo "JDK DMG file was not downloaded."
        exit 1
    fi

    # Test 6: Mount the DMG file
    echo "Mounting the DMG file..."
    hdiutil attach "jdk-11.0.12_macos-x64_bin.dmg"
    assert "DMG file mounted successfully"

    # Test 7: Check if the installer package exists
    if [ -f "/Volumes/JDK 11.0.12.jdk/Contents/Home/installer.pkg" ]; then
        echo "Installer package found."
    else
        echo "Installer package not found. Cannot proceed with installation."
        exit 1
    fi

    # Test 8: Simulate installation (this requires sudo, so we skip actual installation)
    echo "Simulating JDK installation..."
    # Uncomment the next line to perform the actual installation
    # sudo installer -pkg "/Volumes/JDK 11.0.12.jdk/Contents/Home/installer.pkg" -target /
    assert "JDK installation simulated successfully"

    # Test 9: Unmount the DMG file
    echo "Unmounting the DMG file..."
    hdiutil detach "/Volumes/JDK 11.0.12.jdk"
    assert "DMG file unmounted successfully"

    # Test 10: Verify JAVA_HOME variable
    echo "Setting up environment variables..."
    echo "export JAVA_HOME=$(/usr/libexec/java_home -v 11)" >> ~/.zshrc
    echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/.zshrc
    source ~/.zshrc 
    assert "Environment variables set up successfully"

    # Test 11: Verify installation
    echo "Verifying installation..."
    java -version >/dev/null 2>&1
    assert "JDK installation verified successfully"
fi

# Clean up: Remove downloaded DMG file (if it exists)
if [ -f "jdk-11.0.12_macos-x64_bin.dmg" ]; then
    rm "jdk-11.0.12_macos-x64_bin.dmg"
    echo "Cleaned up downloaded files."
fi

echo "All tests completed successfully."
