# Variables
variable "proxmox_node" {
  description = "Proxmox node to deploy containers to"
  default     = "proxmox"
}

variable "template" {
  description = "LXC template to use"
  default     = "secondHDD:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  #secondHDD:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst
  #secondHDD:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz
}

variable "template2" {
  description = "LXC template to use"
  default     = "secondHDD:vztmpl/centos-9-stream-default_20240828_amd64.tar.xz"
  #secondHDD:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst
  #secondHDD:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz
}

variable "ssh_public_key" {
  description = "SSH public key for container access"
  default     = "ssh"
}
