Here's a template for your `README.md` file that you can include with your Ansible project, explaining how to trigger the playbook for an Azure server:

---

# Ansible Deployment Playbook

This repository contains an Ansible playbook to deploy an application to Azure VMs using a PowerShell script. It automates the deployment process for the specified application.

## Prerequisites

- Ansible installed on your control node (local machine or server).
- An Azure VM with SSH access.
- The `ansible/deploy.yml` playbook and required files (such as `scripts/deploy.ps1`) in your project directory.

## Setup

### 1. Install Ansible
Ensure Ansible is installed on your control node:

```bash
sudo apt update
sudo apt install ansible
```

### 2. Create the Azure VM

You can create an Azure VM using the Azure CLI:

```bash
az vm create \
--resource-group <yourResourceGroup> \
--name <yourVMName> \
--image UbuntuLTS \
--admin-username azureuser \
--generate-ssh-keys
```

Open the SSH port (22) if it's not already open:

```bash
az vm open-port --resource-group <yourResourceGroup> --name <yourVMName> --port 22
```

### 3. Configure SSH Access

Ensure you can SSH into your Azure VM using the generated SSH key:

```bash
ssh azureuser@<azure_vm_public_ip>
```

### 4. Inventory File

Create an `inventory.ini` file that includes your Azure VM's public IP:

```ini
[azure_vms]
your_azure_vm ansible_host=<azure_vm_public_ip> ansible_user=azureuser ansible_ssh_private_key_file=~/.ssh/id_rsa
```

- Replace `<azure_vm_public_ip>` with your VM’s public IP address.
- Ensure the `ansible_ssh_private_key_file` points to the correct SSH key for access.

### 5. Playbook Structure

Your Ansible playbook is located in `ansible/deploy.yml`:

```yaml
- hosts: all
  tasks:
    - name: Deploy application
      shell: "powershell.exe -File scripts/deploy.ps1 -appName '{{ item }}'"
      with_items:
        - your_app_name
```

### 6. Running the Playbook

Run the following command to execute the playbook:

```bash
ansible-playbook ansible/deploy.yml -i inventory.ini --extra-vars "item=your_app_name"
```

- `inventory.ini` is the inventory file you created.
- Replace `your_app_name` with the name of your application.

### 7. Verify Ansible Connection

Before running the playbook, you can verify that Ansible can connect to your Azure VM by running:

```bash
ansible azure_vms -i inventory.ini -m ping
```

You should see a `pong` response if the connection is successful.

## PowerShell Script

The deployment script `scripts/deploy.ps1` should exist on the target machine or be accessible to Ansible for execution. Ensure that your PowerShell script handles the deployment process for the application.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

This `README.md` provides clear instructions for setting up the environment and triggering the Ansible playbook for deploying applications on an Azure VM. Let me know if you'd like any changes!
