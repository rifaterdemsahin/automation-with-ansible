Here's an updated version of the `README.md` for using a Mac as the control node for your Ansible deployment.

---

# Ansible Deployment Playbook

This repository contains an Ansible playbook to deploy an application to Azure VMs using a PowerShell script. It automates the deployment process for the specified application, using a Mac as the control node.

## Prerequisites

- Ansible installed on your Mac (control node).
- An Azure VM with SSH access.
- The `ansible/deploy.yml` playbook and required files (such as `scripts/deploy.ps1`) in your project directory.

## Setup

### 1. Install Ansible on macOS

You can install Ansible on your Mac using Homebrew:

```bash
brew update
brew install ansible
```

Verify Ansible installation:

```bash
ansible --version
```

### 2. Create the Azure VM

You can create an Azure VM using the Azure CLI:

1. **Install Azure CLI** on your Mac:

   ```bash
   brew install azure-cli
   ```

2. **Login to Azure**:

   ```bash
   az login
   ```

3. **Create the VM**:

   ```bash
   az vm create \
   --resource-group <yourResourceGroup> \
   --name <yourVMName> \
   --image UbuntuLTS \
   --admin-username azureuser \
   --generate-ssh-keys
   ```

4. **Open the SSH port (22)** if it's not already open:

   ```bash
   az vm open-port --resource-group <yourResourceGroup> --name <yourVMName> --port 22
   ```

### 3. Configure SSH Access

Ensure you can SSH into your Azure VM using the SSH key generated during VM creation. The SSH keys will be stored in `~/.ssh` on your Mac:

```bash
ssh azureuser@<azure_vm_public_ip>
```

### 4. Inventory File

Create an `inventory.ini` file in your project directory to specify the Azure VM details:

```ini
[azure_vms]
your_azure_vm ansible_host=<azure_vm_public_ip> ansible_user=azureuser ansible_ssh_private_key_file=~/.ssh/id_rsa
```

- Replace `<azure_vm_public_ip>` with your VM’s public IP address.
- Ensure the `ansible_ssh_private_key_file` points to your SSH private key file, which by default is `~/.ssh/id_rsa`.

### 5. Playbook Structure

Your Ansible playbook should be located in `ansible/deploy.yml` and structured as follows:

```yaml
- hosts: all
  tasks:
    - name: Deploy application
      shell: "powershell.exe -File scripts/deploy.ps1 -appName '{{ item }}'"
      with_items:
        - your_app_name
```

### 6. Running the Playbook

Run the following command from your Mac to execute the playbook:

```bash
ansible-playbook ansible/deploy.yml -i inventory.ini --extra-vars "item=your_app_name"
```

- `inventory.ini` is the inventory file you created with your Azure VM information.
- Replace `your_app_name` with the actual name of the application you are deploying.

### 7. Verify Ansible Connection

Before running the playbook, you can verify that Ansible can connect to your Azure VM by running:

```bash
ansible azure_vms -i inventory.ini -m ping
```

You should see a `pong` response if the connection is successful.

## PowerShell Script

Ensure that the PowerShell script `scripts/deploy.ps1` exists on the target machine or is accessible for Ansible to execute it. This script should handle the application deployment process.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

This `README.md` is now optimized for users running the Ansible control node on a Mac. Let me know if you need further changes!
