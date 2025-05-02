# Cowrie SSH honeypot containers
resource "proxmox_lxc" "cowrie" {
  count        = 2
  target_node  = var.proxmox_node
  hostname     = "cowrie-${count.index + 1}"
  ostemplate   = var.template
  unprivileged = true
  onboot       = true
  start        = true
  vmid         = 200 + count.index  # IDs: 200-204
  description  = "Cowrie SSH Honeypot ${count.index + 1}"
  
  // Features needed for containerized services
  features {
    nesting = true
  }

  // Root filesystem
  rootfs {
    storage = "secondHDD"
    size    = "8G"
  }
  
  // Network configuration with static
  network {
    name   = "eth0"
    bridge = "vmbr0"
    #ip = "dhcp"
    #ip6 = "dhcp"
    ip     = "192.168.128.${10 + count.index}/24"
    gw     = "192.168.128.1"
  }

  // SSH public key for access
  ssh_public_keys = <<EOF
  ${var.ssh_public_key}
  EOF

  tags = "cowrie,ssh"
}

# Dionaea multi-protocol honeypot containers
resource "proxmox_lxc" "dionaea" {
  count        = 2
  target_node  = var.proxmox_node
  hostname     = "dionaea-${count.index + 1}"
  ostemplate   = var.template
  unprivileged = true
  onboot       = true
  start        = true
  vmid         = 210 + count.index  # IDs: 210-214
  description  = "Dionaea Multi-Protocol Honeypot ${count.index + 1}"
  
  // Features needed for containerized services
  features {
    nesting = true
  }

  // Root filesystem
  rootfs {
    storage = "secondHDD"
    size    = "8G"
  }

  // Network configuration with static
  network {
    name   = "eth0"
    bridge = "vmbr0"
    #ip = "dhcp"
    #ip6 = "dhcp"
    ip     = "192.168.128.${20 + count.index}/24"
    gw     = "192.168.128.1"
  }

  // SSH public key for access
  ssh_public_keys = <<EOF
  ${var.ssh_public_key}
  EOF

  tags = "dionaea,ftp"
}

# Mailoney SMTP honeypot containers
resource "proxmox_lxc" "mailoney" {
  count        = 2
  target_node  = var.proxmox_node
  hostname     = "mailoney-${count.index + 1}"
  ostemplate   = var.template
  unprivileged = true
  onboot       = true
  start        = true
  vmid         = 220 + count.index  # IDs: 220-224
  description  = "Mailoney SMTP Honeypot ${count.index + 1}"
  
  // Features needed for containerized services
  features {
    nesting = true
  }

  // Root filesystem
  rootfs {
    storage = "secondHDD"
    size    = "8G"
  }

  // Network configuration with static
  network {
    name   = "eth0"
    bridge = "vmbr0" #vmbr1 doesnt work yet
    #ip = "dhcp"
    #ip6 = "dhcp"
    ip     = "192.168.128.${30 + count.index}/24"
    gw     = "192.168.128.1"
  }

  // SSH public key for access
  ssh_public_keys = <<EOF
  ${var.ssh_public_key}
  EOF

  tags = "mailoney,smtp"
}
