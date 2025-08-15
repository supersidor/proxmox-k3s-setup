provider "proxmox" {
  pm_api_url                  = var.api_url
  pm_tls_insecure             = "true"
  pm_debug                    = true
  pm_timeout                  = 300
  pm_minimum_permission_check = false
}
#
# locals {
#   vm_settings = merge(flatten([for i in fileset(".", "vars/nodes.yaml") : yamldecode(file(i))["nodes"]])...)
#   network     = yamldecode(file("vars/network.yaml"))
#   db          = yamldecode(file("vars/db.yaml"))
# }
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
# resource "local_file" "ansible_inventory" {
#   content = templatefile("templates/hosts.tmpl",
#     {
#       primary   = { "name" = local.vm_settings.master0.name, "ip" = local.vm_settings.master0.ip } #[for j in local.vm_settings : { "name" : j.name, "ip" : j.ip } if j.name == local.vm_settings.master0.name]
#       secondary = [for j in local.vm_settings : { "name" : j.name, "ip" : j.ip } if j.type == "master" && j.name != local.vm_settings.master0.name]
#       workers   = [for j in local.vm_settings : { "name" : j.name, "ip" : j.ip } if j.type == "worker"]
#       nginx     = { "name" = local.vm_settings.haproxy.name, "ip" = local.vm_settings.haproxy.ip }
#       mysql     = { "name" = local.vm_settings.database.name, "ip" = local.vm_settings.database.ip }
#       db        = { "user" = local.db.user, "dbname" = local.db.dbname, "password" = local.db.pwd }
#     }
#   )
#   filename = "inventory/hosts.ini"
# }
#
# resource "local_file" "nginx_conf" {
#   content = templatefile("templates/nginx.tmpl",
#     {
#       control  = [for j in local.vm_settings : j.ip if j.type == "master"]
#       mysql_ip = local.vm_settings.database.ip
#     }
#   )
#   filename = "files/nginx.conf"
# }

resource "proxmox_vm_qemu" "myvm" {
  name                    = "terraform-vm1"
  target_node             = "home1"                 # Node where VM will be created
  clone                   = "ubuntu-noble-template" # Name of the existing template VM
  full_clone              = true                   # true = independent copy, false = linked clone
  memory                  = 4096
  bios                    = "ovmf"
  tags                    = "test"
  bootdisk                = "virtio"
  scsihw                  = "virtio-scsi-single"
  agent = 1
  ciuser     = "test"
  cipassword = "test"
  cicustom   = "vendor=local:snippets/ubuntu.yaml" # /var/lib/vz/snippets/qemu-guest-agent.yml


  cpu {
    cores   = 2
    sockets = 1
  }

  # disk {
  #   slot    = "scsi0"
  #   size    = "20G"
  #   type    = "disk"
  #   storage = "local-lvm"
  # }

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
          size    = "20G"
          discard = true
        }
      }

    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  serial {
    id   = 0
    type = "socket"
  }
  vga {
    type = "serial0"
  }

  os_type = "cloud-init" # if the template is a cloud-init template
  ipconfig0 = "ip=dhcp"
  boot = "order=virtio0"

}
