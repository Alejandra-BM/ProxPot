# Variables
variable "proxmox_node" {
  description = "Proxmox node to deploy containers to"
  default     = "name of the node"
}

variable "templateVM" { # not used in code
  description = "VM template to use"
  default     = "VM 9000"
}

variable "ssh_public_key" {
  description = "SSH public key for container access"
  default     = "ssh rsa ..."
}

variable "password" { # not used in code
  description = "cipassword"
  default = "...."
}

variable "user" { # not used in code
  description = "ciuser"
  default = "..."
}
