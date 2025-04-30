
<pre>
<div align="center">

.·:''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':·.
: :    _______    _______     ______  ___  ___    _______    ______  ___________  : :
: :   |   __ "\  /"      \   /    " \|"  \/"  |  |   __ "\  /    " \("     _   ") : :
: :   (. |__) :)|:        | // ____  \\   \  /   (. |__) :)// ____  \)__/  \\__/  : :
: :   |:  ____/ |_____/   )/  /    ) :)\\  \/    |:  ____//  /    ) :)  \\_ /     : :
: :   (|  /      //      /(: (____/ // /\.  \    (|  /   (: (____/ //   |.  |     : :
: :  /|__/ \    |:  __   \ \        / /  \   \  /|__/ \   \        /    \:  |     : :
: : (_______)   |__|  \___) \"_____/ |___/\___|(_______)   \"_____/      \__|     : :
'·:...............................................................................:·'                                                                                

</div>
</pre>

# **Proxmox VE – Automated VM Honeypot Setup**

This project automates the deployment and provisioning of honeypot virtual machines using **Proxmox VE**, **Terraform**, and **Ansible**.

---

## 🖥️ Base VM Template Setup (Ubuntu 22.04)

Before running the Terraform script, follow these steps on your **Proxmox VE host** to create a cloud-init-enabled VM template:

1. Download the Ubuntu 22.04 minimal cloud image:

   ```bash
   wget https://cloud-images.ubuntu.com/minimal/releases/jammy/release/ubuntu-22.04-minimal-cloudimg-amd64.img
   ```

2. Create a new VM:

   ```bash
   qm create 9000 --memory 2048 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci
   ```

3. Import the disk image:

   ```bash
   qm set 9000 --scsi0 local-lvm:0,import-from=/root/ubuntu-22.04-minimal-cloudimg-amd64.img
   ```

4. Attach cloud-init drive:

   ```bash
   qm set 9000 --ide2 local-lvm:cloudinit
   ```

5. Set the boot order and enable serial console:

   ```bash
   qm set 9000 --boot order=scsi0
   qm set 9000 --serial0 socket --vga serial0
   ```

6. Convert the VM to a template:

   ```bash
   qm template 9000
   ```

This results in a base template (VM ID `9000`) ready to be used by Terraform for dynamic VM creation.

---

## ⚙️ Deploying VMs with Terraform

Navigate to the `./tf` directory and run:

```bash
terraform plan
terraform apply
```

---

## 🔧 Provisioning VMs with Ansible

Use the `provision.yaml` playbook located in `./ansible` to install required tools like `qemu-guest-agent` and `Docker`.

Provision a single VM:

```bash
ansible-playbook -i inventory.ini provision.yaml -l vm1 -u ubuntu
```

Provision all honeypots (as defined in the `honeypots` group in `inventory.ini`):

```bash
ansible-playbook -i inventory.ini provision.yaml -l honeypots -u ubuntu
```

---

## 🍯 Deploying Honeypots

To install and start all honeypot services on the provisioned VMs:

```bash
ansible-playbook playbook.yml -i inventory.ini -u ubuntu
```

Once the playbook finishes, the honeypot services should be up and running.

---

## 🚀 Requirements

- Proxmox VE installed on host machine
- Terraform
- Ansible
- Ubuntu 22.04 cloud image
- Internet access for VMs (for downloading packages)

---

## ⚖️ License

This project is part of my final thesis and is not publicly licensed for use, modification, or distribution until it has been officially submitted and presented.
