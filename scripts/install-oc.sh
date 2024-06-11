#!/bin/bash

# Check if oc CLI is installed
if command -v oc &> /dev/null; then
  echo "OpenShift CLI (oc) is already installed. Skipping installation."
else
  echo "OpenShift CLI (oc) is not installed. Installing..."
  # Install oc CLI
  curl -s https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz | tar -xz
  sudo mv oc /usr/local/bin/
  sudo chmod +x /usr/local/bin/oc
  echo "OpenShift CLI (oc) installed successfully."
fi