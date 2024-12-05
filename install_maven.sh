#!/bin/bash

# Define the version of Maven to download
MAVEN_VERSION="3.9.9"
MAVEN_URL="https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz"

# Define installation directory 
INSTALL_DIR="/opt/maven"

# Check if maven is already installed 
if command -v mvn &> /dev/null; then 
    echo "Maven is already installed. Version $(mvn -v)"
    exit 0
fi

# Create installation directory
echo "Creating installation directory at $INSTALL_DIR..."
sudo mkdir -p $INSTALL_DIR

# Download Maven
echo "Downloading Maven ${MAVEN_VERSION}..."
wget $MAVEN_URL -O /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz

# Extract the downloaded file
echo "Extracting Maven..."
sudo tar -xzf /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz -C $INSTALL_DIR

# Set up environment variables
echo "Setting up environment variables..."
echo "export MAVEN_HOME=$INSTALL_DIR/apache-maven-${MAVEN_VERSION}" >> ~/.bash_profile
echo "export PATH=\$PATH:\$MAVEN_HOME/bin" >> ~/.bash_profile

# Clean up the downloaded file
rm /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz

# Verify installation
echo "Maven installation completed. Verifying installation..."
mvn -v

echo "Maven ${MAVEN_VERSION} has been installed successfully."