📦 Terraform Infrastructure – Azure Monolithic App (Frontend + Backend, With Data Block) This Terraform project provisions the infrastructure for a monolithic ToDo application hosted on Azure, structured into modular components without using loops (count, for_each, etc.).

✅ Features 🚀 Frontend and Backend hosted on separate Azure VMs

🚀 Installing NGINX on the frontend VM using Terraform’s null_resource and remote-exec provisioner

⚙️ Existing Azure resources are accessed using Terraform data blocks

🌐 Virtual Network with subnet isolation between app layers

🔐 Network Security Groups (NSGs) for access control

❌ No Azure Storage Accounts used

🔐 Credentials are securely accessed from Azure Key Vault using the secret reference method

📦 Each resource group is declared manually via modules (no iteration logic)

🔧 Components Provisioned Module Resource Summary network VNet, 2 subnets (frontend & backend), NSGs frontend_vm Linux VM (e.g., Ubuntu with Nginx) backend_vm Linux VM (e.g., Python Flask)
