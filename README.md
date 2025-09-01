<div align="center">
<pre>
   _______    _______     ______  ___  ___    _______    ______  ___________  
  |   __ "\  /"      \   /    " \|"  \/"  |  |   __ "\  /    " \("     _   ") 
  (. |__) :)|:        | // ____  \\   \  /   (. |__) :)// ____  \)__/  \\__/  
  |:  ____/ |_____/   )/  /    ) :)\\  \/    |:  ____//  /    ) :)  \\_ /     
  (|  /      //      /(: (____/ // /\.  \    (|  /   (: (____/ //   |.  |     
 /|__/ \    |:  __   \ \        / /  \   \  /|__/ \   \        /    \:  |     
(_______)   |__|  \___) \"_____/ |___/\___|(_______)   \"_____/      \__|     
                                                                              
</pre>
</div>

# **ProxPot – Automated VM Honeypot Setup**

This project automates the deployment and provisioning of honeypot virtual machines using **Proxmox VE**, **Terraform**, and **Ansible**. It also includes the configuration of a sandbox environment with **EFK** for viewing logs and performing thorough analysis of attacks.

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
ansible-playbook -i inventory.ini provision.yaml -l vm0 -u ubuntu
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
### 📦 Playbook Overview

The playbook includes **five roles**:

1. **Honeypot Services**
- Cowrie and Mailoney: Deployed via Docker
- Dionaea: Installed natively on the host

**Cowrie** emulates an SSH server, exposing port 2222. **Mailoney** simulates an SMTP server on port 25. **Dionaea** exposes ports 21 and 80, acting as both an FTP and HTTP server.

2. **Log Collection**
- A cron job runs every 2 minutes to extract and convert logs from Cowrie and Mailoney containers into JSON files formatted for Fluent Bit. It also

3. **Fluent Bit Setup**
- Installs Fluent Bit on each small VM (as defined in inventory.ini) and configures it to forward logs to a central Fluentd instance on the big VM, which runs an EFK (Elasticsearch, Fluentd, Kibana) stack for log analysis.

Once the playbook finishes, all honeypot services and the log pipeline should be fully operational.

---

## ⌛ Sandbox

The main virtual machine, acting as a sandbox for collecting files and logs, is a standard VM configured with the **EFK stack** (Elasticsearch, Fluentd, Kibana), following the setup described [here](https://adamtheautomator.com/efk-stack/).

To launch the EFK stack, navigate to the `./sandbox/efk` directory and run:

```bash
docker-compose up
```

This command will start the Docker containers for **Elasticsearch, Fluentd,** and **Kibana**.
Fluentd will automatically load its configuration from the `./sandbox/efk/fluentd/conf` directory.
TLS is enabled to secure communication, which is especially important when working with cloud services.

---

## 🔧 Tools

In `./tools` here are Python scripts that extract bistream data from Dionaea and playlog information from Cowrie. These tools are useful for conducting deeper analysis of attacker behavior and intelligence.

---

## 🚀 Requirements

- Proxmox VE installed on host machine (only for the Terraform deployment)
- Terraform
- Ansible
- Ubuntu 22.04 cloud image
- Exposed ports
- Sandbox (big VM) for log analysis
- Internet access for VMs (for downloading packages)

---

## 🎯 Modular Environment in Action

As mentioned, there will therefore be two deployments (in Azure and Proxmox), with a total of three VMs. Here's how everything works when an attacker takes the bait:

![Modular Environment Working Example](<img width="6948" height="4164" alt="image" src="https://github.com/user-attachments/assets/bfea2f60-9c5e-431a-b507-8a42eb98a5cd" />)

---

## ⚖️ License

This project is part of my final thesis and is not publicly licensed for use, modification, or distribution until it has been officially submitted and presented.
