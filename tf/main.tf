resource "proxmox_vm_qemu" "VM-HoneyPot" {
  count        = 2
  name         = "VM-HoneyPot-${count.index + 1}"
  target_node  = var.proxmox_node
  clone        = "VM 9000"
  vmid         = 400 + count.index
  full_clone   = true

  agent        = 1

  cores        = 2
  sockets      = 1
  vcpus        = 0
  cpu_type     = "host"
  memory       = 2048
  os_type      = "cloud-init"
  scsihw       = "virtio-scsi-pci"
  bootdisk     = "scsi0"

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }

    scsi {
      scsi0 {
        disk {
          size         = 32
          storage      = "secondHDD"
          cache        = "writeback"
          discard      = true
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.100.1${count.index + 10}/24,gw=192.168.100.1"

  sshkeys = <<EOF
  ${var.ssh_public_key}
  EOF

  tags = "honeypot"
}
