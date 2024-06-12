#!/bin/bash

# Define the directory where Terraform files are located
terraform_dir="terraform"

# Define the output file for Terraform output
output_file="terraform_output.txt"

# Run Terraform init
cd "$terraform_dir" || exit
terraform init

# Run Terraform apply and save the output
terraform apply -auto-approve | tee "$output_file"

# Extract public IP from Terraform output
public_ip==$(terraform output -json ec2_instance_ips | jq -r '.[]')

# Define the Ansible inventory file
ansible_inventory="ansible/inventory"

# Check if public IP already exists in inventory file
if grep -q "$public_ip" "$ansible_inventory"; then
    echo "Public IP already exists in inventory file."
else
    # Add the public IP to the inventory file
    echo "[$(hostname)]" >> "$ansible_inventory"
    echo "public_ip=$public_ip" >> "$ansible_inventory"
    echo "IP added to inventory file."
fi

cd ..
cd ansible/
ansible-playbook -i inventory/hosts install_tools.yml
