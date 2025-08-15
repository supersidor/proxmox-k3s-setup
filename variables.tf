variable "api_url" {
  description = "URL to the API of Proxmox"
  type        = string
  default     = "https://192.168.50.134:8006/api2/json"
}


variable "token" {
  description = "token for auth"
  type        = string
  default = "apiuser@pve!mytoken=a40facf6-0251-46e8-bfac-a63ef3181b4c"
}

variable "target_host" {
  description = "Hostname to deploy to"
  default     = "home1"
  type        = string
}

variable "storage_name" {
  description = "Storage name on Proxmox server"
  default     = "local-lvm"
  type        = string
}

variable "template_name" {
  description = "Name of the template to clone"
  type        = string
  default     = "a2buntu"
}

variable "pool" {
  type        = string
  description = "In what pool is this deployed ?"
  default     = "lab-kubernetes"
}

variable "ansible_password" {
  type        = string
  description = "Password for the ansible user"
  default     = "test"
}
variable "ansible_public_ssh_key" {
  type        = string
  description = "Private SSH key for the user ansible"
  default     = "test"

}
