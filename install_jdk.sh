#!/bin/bash
echo "Running script"

# Define the JDK version and download URL 
JDK_VERSION="11.0.12"
JDK_BUILD="11.0.12+7"
JDK_URL="https://download.oracle.com/java/11/archive/jdk-${JDK_VERSION}_macos-x64_bin.dmg"

# Check if the JDK is already installed 
if /usr/libexec/java_home -v 11 &> /dev/null; then 
    echo "JDK 11 is already installed. Version: $(/usr/libexec/java_home -v 11)"
    exit 0
fi

# Download JDK 
echo "Downloading JDK ${JDK_VERSION}..."
curl -L -O "$JDK_URL"

# Mount the DMG file
echo "Mounting the DMG file..."
hdiutil attch "jdl-${JDK_VERSION}_macos-x64_bin.dmg"

# Install the JDK
echo "Installing JDk ${JDK_VERSION}..."
sudo installer -pkg "/Volumes/JDK 11.0.12.jdk/Contents/Home/installer.pkg" -target /

# Unmount the DMG file 
echo "Unmounting the DMG file..."
hdiutil detach "/Volumes/JDK 11.0.12.jdk"

# Set up environment variables 
echo "Setting up environment variables..."
echo "export JAVA_HOME=$(/usr/libexec/java_home -v 11)" >> ~/.zshrc
echo "export PATH=$JAVA_HOME/bin:$PATH" >> ~/.zshrc

# Apply the change to .zshrc
source ~/.zshrc 

# Verify installation
echo "JDK installation completed. Verifying installation..."
java -version 

echo "JDK ${JDK_VERSION} has been installed successfully."