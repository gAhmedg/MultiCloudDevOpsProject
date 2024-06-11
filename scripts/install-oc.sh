#!/bin/bash

# Function to check if oc is installed
check_oc_installed() {
    if command -v oc &> /dev/null
    then
        echo "oc CLI is already installed."
        return 0
    else
        echo "oc CLI is not installed."
        return 1
    fi
}

# Function to install oc CLI
install_oc() {
    echo "Installing oc CLI..."
    
    # Download the oc client
    curl -LO "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz"
    
    # Extract the tar.gz file
    tar -zxvf openshift-client-linux.tar.gz
    
    # Move oc and kubectl to /usr/local/bin
    sudo mv oc /usr/local/bin/
    sudo mv kubectl /usr/local/bin/
    
    # Cleanup
    rm -f openshift-client-linux.tar.gz
    rm -f kubectl  # Remove the kubectl binary if it's not needed
    
    echo "oc CLI installed successfully."
}

# Main script logic
if ! check_oc_installed; then
    install_oc
fi
