#!/bin/zsh

ansible-playbook snapshot-vms.yaml -e "proxmox_password=Hello123" -e "snapshot_name=start"