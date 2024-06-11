#!/bin/bash

# Ignore the Corretto repository specifically
sudo yum-config-manager --disable corretto

# Update the system packages while ignoring the Corretto repository
sudo yum update --disablerepo=corretto -y || true

# Install necessary dependencies
sudo yum install -y wget tar

# Set the OpenShift CLI version you want to install
OC_VERSION="latest"

# Get the latest release download URL for the OpenShift CLI
OC_DOWNLOAD_URL=$(curl -s https://mirror.openshift.com/pub/openshift-v4/clients/ocp/$OC_VERSION/release.txt | grep 'linux-64' | awk '{print $2}')

# Download the OpenShift CLI tarball
wget $OC_DOWNLOAD_URL -O /tmp/openshift-client.tar.gz

# Extract the tarball
tar -xvf /tmp/openshift-client.tar.gz -C /tmp

# Move the oc binary to /usr/local/bin
sudo mv /tmp/oc /usr/local/bin

# Verify the installation
oc version

# Clean up
rm -f /tmp/openshift-client.tar.gz
rm -f /tmp/kubectl

echo "OpenShift CLI installation is complete."
