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

# Test 1: Check if wget is installed
command -v wget >/dev/null 2>&1
assert "wget is installed"

# Test 2: Check if the /tmp directory is writable
touch /tmp/testfile
assert "Writable /tmp directory"
rm /tmp/testfile

# Test 3: Check if the jdk-11.tar.gz file can be downloaded
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http://www.oracle.com;" \
     "https://download.oracle.com/java/11/archive/jdk-11.0.12_linux-x64_bin.tar.gz" -O /tmp/jdk-11.tar.gz
assert "Java JDK tar.gz file downloaded successfully"

# Test 4: Check if the extraction works
sudo mkdir -p /usr/lib/jvm
sudo tar -xzf /tmp/jdk-11.tar.gz -C /usr/lib/jvm
assert "Java JDK extracted successfully"

# Test 5: Check if JAVA_HOME is set correctly (check existence of directory)
if [ -d "/usr/lib/jvm/jdk-11.0.12" ]; then
    echo "JAVA_HOME directory exists."
else
    echo "JAVA_HOME directory does not exist."
    exit 1
fi

# Clean up the downloaded file
rm /tmp/jdk-11.tar.gz