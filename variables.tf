variable "api_url" {
  description = "URL to the API of Proxmox"
  type        = string
  default     = "https://192.168.50.134:8006/api2/json"
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
  description = "Public SSH key for the user ansible"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRl+8d55mACBNJtkhQODECR+OZMbm+aOgKGihFey6Q8ZMqUpOJ8sUlpN+gx40rkWoR90gxE4OU8QzxV3TW2JKEvnM97TJwHUyM8wUwn2vOEkYNYz6UCZ8sfai+XIfUKmbQNcLAOCvoFE2dAvZsP91UtKCj/o8G64t4uwPaG6KDhELvuRFU7A7Bf8yhsNctl3oYk2788/O4mq0Qf3oO89K0vklAXen3R1yndqZLyo90oEfj3Bz4LQpj1gvF+GJxdDwwWsY1BnSSLa8GBdFpKZxBIIIOBz1dDjqC0Ui6yPLnw+ah7Oi+sB2vfudX2qT0qYP9AjFvq7XiBPHQDC/H5ShdlAWiJH9NBf94ThojQ0xis/evxPOYyQkSi0UEAysnGuuhjpDeUSUEUKAFc/DoZklBwdMdeirDTPOKlAyWND9PCZDc8ATu+BLo1p+4eZBcUSMHj+h4o33YihV06MTcEx8GhjkoKYRQCpDtCIsaE1tbbBO6aUAiSEtbVq9hKiWBGfc= supersidor@Andriys-MBP"

}
