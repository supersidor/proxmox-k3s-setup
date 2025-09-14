#!/bin/zsh

# Check if snapshot name parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <snapshot_name>"
    echo "Example: $0 start"
    exit 1
fi

echo "Creating snapshot: $1"
ansible-playbook snapshot-vms.yaml -e "proxmox_password=Hello123" -e "snapshot_name=$1"