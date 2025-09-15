# ArgoCD Installation

This document describes how to use the extracted ArgoCD playbook.

## Usage

### Install ArgoCD after K3s setup

```bash
# First, install K3s cluster (without ArgoCD)
ansible-playbook -i inventory/hosts.ini install-k3s.yaml

# Then, install ArgoCD separately
ansible-playbook -i inventory/hosts.ini install-argocd.yaml
```

### Custom ArgoCD Configuration

You can override default variables:

```bash
ansible-playbook -i inventory/hosts.ini install-argocd.yaml \
  -e argocd_namespace=argocd-prod \
  -e argocd_admin_password=mySecurePassword123
```

### Available Variables

- `argocd_namespace`: Namespace to install ArgoCD (default: `argocd`)
- `argocd_admin_password`: Admin password for ArgoCD (default: `admin`)
- `argocd_manifests_url`: URL to ArgoCD installation manifests

### Prerequisites

- K3s cluster must be running
- kubectl access configured on the primary control plane node
- ArgoCD manifest files in `manifests/` directory:
  - `argocd-cmd-params-cm.yaml`
  - `argocd-server-ingress.yaml`

## Benefits of Separate Playbook

1. **Modularity**: Install ArgoCD independently from K3s setup
2. **Reusability**: Use with existing K3s clusters
3. **Maintenance**: Update ArgoCD configuration without touching K3s setup
4. **Testing**: Test ArgoCD installation separately