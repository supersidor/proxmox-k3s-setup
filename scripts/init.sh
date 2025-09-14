#!/bin/zsh

# Base ansible-playbook command
ANSIBLE_CMD="ansible-playbook -vv -i inventory/hosts.ini setup-k3s.yaml -u test --private-key ~/.ssh/id_rsa"

# Check if limit parameter is provided
if [ -n "$1" ]; then
    echo "Running playbook with limit: $1"
    ANSIBLE_CMD="$ANSIBLE_CMD --limit $1"
else
    echo "Running playbook for all hosts"
fi

# Execute the command
eval $ANSIBLE_CMD