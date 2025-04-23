# PROXMOX VM Honeypot Automatization
These VMs contain the template Ubuntu 22.04. Done by following these steps: https://pve.proxmox.com/wiki/Cloud-Init_Support#_preparing_cloud_init_templates. 
Please, do before the Terraform script, and follow these steps in the PROXMOX VE host.
```bash
wget https://cloud-images.ubuntu.com/min...lease/ubuntu-22.04-minimal-cloudimg-amd64.img
```
```bash
qm create 9000 --memory 2048 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci

```
```bash
qm set 9000 --scsi0 local-lvm:0,import-from=/path/to/bionic-server-cloudimg-amd64.img
```

```bash
qm set 9000 --ide2 local-lvm:cloudinit
```
```bash
qm set 9000 --boot order=scsi0
```
```bash
qm set 9000 --serial0 socket --vga serial0
```
```bash
qm template 9000
```
This should result in a template, called VM 9000. Once the template appears in PROXMOX, its ready to use and the Terraform script will use it to make the VMs.

Deploy VMs using the following Terraform script, located in ./tf
```bash
terraform apply
```
```bash
terraform plan
```
```bash
terraform deploy
```

For provisioning, use the ansible playbook (in ./ansible) called provision.yaml to install the qemu-guest-agent and docker. You can choose which VM to provision, one or all (inventory.ini for references).
```bash
ansible-playbook -i inventory.ini provision.yaml -l vm1 -u ubuntu
```
