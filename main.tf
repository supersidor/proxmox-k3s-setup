provider "proxmox" {
  pm_api_url                  = var.api_url
  pm_tls_insecure             = "true"
  pm_debug                    = true
  pm_timeout                  = 300
  pm_minimum_permission_check = false
}
#
locals {
  vm_settings = {
    for k, v in merge(flatten([for i in fileset(".", "vars/nodes.yaml") : yamldecode(file(i))["nodes"]])...) :
    k => merge(v, {
      host_name = "${v.node}-${v.name}"
    })
  }
  # network     = yamldecode(file("vars/network.yaml"))
  # db          = yamldecode(file("vars/db.yaml"))
}
#
# resource "proxmox_vm_qemu" "cloudinit-nodes" {
#   for_each    = local.vm_settings
#   name        = each.key
#   vmid        = each.value.vmid
#   target_node = var.target_host
#   clone       = each.value.os
#   full_clone  = true
#   boot        = "order=scsi0;net0" # "c" by default, which renders the coreos35 clone non-bootable. "cdn" is HD, DVD and Network
#   agent       = 0
#   tags        = "k3s,${each.value.type}"
#   vm_state    = each.value.boot # start once created ?
#
#   # Configure the cloudinit parts ...
#   #cicustom   = "vendor=local:snippets/qemu-guest-agent.yml" # /var/lib/vz/snippets/qemu-guest-agent.yml
#   #ciupgrade  = true
#   nameserver = local.network.dns
#   ipconfig0  = "ip=dhcp"
#   skip_ipv6  = true
#   ciuser     = "test"
#   cipassword = "test"
#  # sshkeys    = var.ansible_public_ssh_key
#
#   cpu {
#     cores = each.value.cores
#   }
#   memory   = each.value.ram
#   scsihw   = "virtio-scsi-pci"
#   bootdisk = "scsi0"
#   hotplug  = 0
#   disks {
#     scsi {
#       scsi0 {
#         disk {
#           storage = "local-lvm"
#           size    = "120G"
#         }
#       }
#     }
#     ide {
#       ide0 {
#         cloudinit {
#           storage = "local-lvm"
#         }
#       }
#     }
#   }
#   network {
#     id       = 0
#     model    = "virtio"
#     bridge   = local.network.bridge
#     macaddr  = each.value.macaddr
#   }
# }
#


resource "proxmox_vm_qemu" "cloudinit-nodes" {
  for_each    = local.vm_settings
  name        = each.value.host_name
  target_node = each.value.node
  vmid        = each.value.vmid
  clone       = each.value.os
  full_clone  = true
  memory      = each.value.ram
  bios        = "ovmf"
  bootdisk   = "virtio"
  scsihw     = "virtio-scsi-single"
  agent      = 1
  ciuser     = "test"
  cipassword = "test"
  cicustom   = "vendor=local:snippets/ubuntu.yaml" # /var/lib/vz/snippets/qemu-guest-agent.yml
  sshkeys    = var.ansible_public_ssh_key
  tags       = "k3s,${each.value.type}"
  cpu {
    cores   = each.value.cores
    sockets = 1
  }

  lifecycle {
    ignore_changes = [bootdisk]
  }

  disks {
    scsi {
      scsi1 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          storage = "local-lvm"
          size    = each.value.disksize
          discard = true
        }
      }

    }
  }

  network {
    id      = 0
    model   = "virtio"
    bridge  = "vmbr0"
    macaddr = each.value.macaddr
  }

  serial {
    id   = 0
    type = "socket"
  }
  vga {
    type = "serial0"
  }

  os_type   = "cloud-init" # if the template is a cloud-init template
  ipconfig0 = "ip=dhcp"
  boot      = "order=virtio0"

}

resource "local_file" "ansible_inventory" {
  content = templatefile("templates/hosts.tmpl",
    {
      primary   = { "name" = local.vm_settings.master1.host_name, "ip" = local.vm_settings.master1.ip, "node" = local.vm_settings.master1.node }
      secondary = [for j in local.vm_settings : { "name" : j.host_name, "ip" : j.ip , "node" : j.node } if j.type == "master" && j.name != local.vm_settings.master1.name]
      workers   = [for j in local.vm_settings : { "name" : j.host_name, "ip" : j.ip, "node" : j.node } if j.type == "worker"]
      nginx     = { "name" = local.vm_settings.haproxy.host_name, "ip" = local.vm_settings.haproxy.ip }
    }
  )
  filename = "inventory/hosts.ini"
}

resource "local_file" "nginx_conf" {
  content = templatefile("templates/nginx.tmpl",
    {
      control = [for j in local.vm_settings : j.ip if j.type == "master"]
    }
  )
  filename = "files/nginx.conf"
}
