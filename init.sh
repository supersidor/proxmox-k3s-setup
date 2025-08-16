#!/bin/zsh

ansible-playbook -vv -i inventory/hosts.ini setup-k3s.yaml -u test --private-key ~/.ssh/id_rsa