#!/bin/zsh

ansible-playbook revert-snapshot.yaml -e "proxmox_password=Hello123" -e "snapshot_name=start"