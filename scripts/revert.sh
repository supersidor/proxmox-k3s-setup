#!/bin/zsh

# Check if snapshot name parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <snapshot_name>"
    echo "Example: $0 start"
    exit 1
fi

echo "Reverting to snapshot: $1"
ansible-playbook revert-snapshot.yaml -e "proxmox_password=Hello123" -e "snapshot_name=$1"