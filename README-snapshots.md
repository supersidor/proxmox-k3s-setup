# Proxmox VM Snapshot Management

This directory contains Ansible playbooks to manage Proxmox VM snapshots for your K3S cluster.

## Files

- `snapshot-vms.yaml` - Main playbook to create snapshots of all VMs
- `revert-snapshot.yaml` - Playbook to revert all VMs to a specific snapshot
- `vars/proxmox_creds.yaml` - Credentials file (encrypt with ansible-vault)

## Usage

### Creating Snapshots

#### 1. Basic Usage (with inline credentials)
```bash
ansible-playbook snapshot-vms.yaml -e "proxmox_password=your-password"
```

#### 2. Custom snapshot name
```bash
ansible-playbook snapshot-vms.yaml -e "proxmox_password=your-password" -e "snapshot_name=before-k8s-upgrade"
```

#### 3. Using the credentials file
First, encrypt the credentials file:
```bash
ansible-vault encrypt vars/proxmox_creds.yaml
```

Then run with vault password:
```bash
ansible-playbook snapshot-vms.yaml --ask-vault-pass
```

#### 4. Custom snapshot name with encrypted credentials
```bash
ansible-playbook snapshot-vms.yaml --ask-vault-pass -e "snapshot_name=my-custom-snapshot"
```

#### 5. Dry run to see what will be snapshotted
```bash
ansible-playbook snapshot-vms.yaml --check -e "proxmox_password=your-password"
```

### Reverting to Snapshots

#### 1. Basic revert to snapshot
```bash
ansible-playbook revert-snapshot.yaml -e "proxmox_password=your-password" -e "snapshot_name=before-k8s-upgrade"
```

#### 2. Revert without auto-starting VMs
```bash
ansible-playbook revert-snapshot.yaml -e "proxmox_password=your-password" -e "snapshot_name=before-maintenance" -e "start_vms_after_revert=false"
```

#### 3. Revert with excluded VMs
```bash
ansible-playbook revert-snapshot.yaml -e "proxmox_password=your-password" -e "snapshot_name=backup-dec-2024" -e "exclude_vm_list=['haproxy','master1']"
```

#### 4. Skip confirmation prompt (dangerous!)
```bash
ansible-playbook revert-snapshot.yaml -e "proxmox_password=your-password" -e "snapshot_name=before-upgrade" -e "skip_confirmation=true"
```

#### 5. Revert with encrypted credentials
```bash
ansible-playbook revert-snapshot.yaml --ask-vault-pass -e "snapshot_name=pre-maintenance"
```

## Features

### Snapshot Creation
- **Custom snapshot naming**: Pass `-e "snapshot_name=your-name"` for custom names, or use automatic timestamp format (YYYYMMDD-HHMM)
- **Error handling**: Continues even if one VM fails
- **Retry logic**: Retries failed snapshots up to 3 times
- **Summary reporting**: Shows success/failure count
- **Snapshot listing**: Optional second play to list existing snapshots

### Snapshot Reversion
- **Safety checks**: Confirmation prompt with warning about data loss
- **VM exclusion**: Skip specific VMs from revert operation
- **Auto VM management**: Automatically stops VMs before revert, optionally starts them after
- **Status verification**: Post-revert status check for all VMs
- **Detailed reporting**: Shows success/failure for each VM operation
- **Flexible control**: Options to skip confirmation, disable auto-start, etc.

## VM Coverage

The playbook will snapshot all VMs defined in `vars/nodes.yaml`:
- HAProxy: VMID 200 (k3s-nginx)
- Masters: VMIDs 210-212 (k3s-ctrl-1 to k3s-ctrl-3)  
- Workers: VMIDs 220-224 (k3s-worker-1 to k3s-worker-5)

## Security Notes

- Always use `ansible-vault` to encrypt the credentials file in production
- Consider using API tokens instead of passwords for better security
- The playbook disables SSL certificate validation (`validate_certs: false`)

## Examples

### Snapshot Creation Examples
```bash
# Create snapshot with default timestamp name
ansible-playbook snapshot-vms.yaml -e "proxmox_password=secret123"

# Create snapshot before maintenance
ansible-playbook snapshot-vms.yaml -e "proxmox_password=secret123" -e "snapshot_name=before-maintenance"

# Create snapshot before upgrade
ansible-playbook snapshot-vms.yaml -e "proxmox_password=secret123" -e "snapshot_name=pre-k3s-v1.28-upgrade"
```

### Snapshot Revert Examples
```bash
# Revert all VMs to a maintenance snapshot
ansible-playbook revert-snapshot.yaml -e "proxmox_password=secret123" -e "snapshot_name=before-maintenance"

# Revert but exclude HAProxy from the operation
ansible-playbook revert-snapshot.yaml -e "proxmox_password=secret123" -e "snapshot_name=pre-upgrade" -e "exclude_vm_list=['haproxy']"

# Emergency revert without confirmation (use with extreme caution!)
ansible-playbook revert-snapshot.yaml -e "proxmox_password=secret123" -e "snapshot_name=working-state" -e "skip_confirmation=true"
```

## Important Safety Notes

⚠️ **WARNING**: The revert operation is **DESTRUCTIVE** and **IRREVERSIBLE**!
- All data created after the snapshot will be permanently lost
- The playbook includes confirmation prompts to prevent accidental execution
- Always test the revert process in a non-production environment first
- Consider creating a new snapshot before reverting as a safety backup