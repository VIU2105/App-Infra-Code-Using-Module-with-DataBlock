data "azurerm_subnet" "subnets" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.nic_rg_name
}

data "azurerm_public_ip" "pip_ip" {
  name                = var.name_of_public_ip
  resource_group_name = var.nic_rg_name
}
# data "azurerm_key_vault_secrets" "kv_secrets" {
#   key_vault_id = data.azurerm_key_vault.todo_app_kv.id
# }
data "azurerm_key_vault" "todo_app_kv" {
  name                = var.key_vault_name
  resource_group_name = var.nic_rg_name
}

data "azurerm_key_vault_secret" "kv_secret_user" {
  name         = var.kv_secret_username
  key_vault_id = data.azurerm_key_vault.todo_app_kv.id
}

data "azurerm_key_vault_secret" "kv_secret_pass" {
  name         = var.kv_secret_pass
  key_vault_id = data.azurerm_key_vault.todo_app_kv.id
}

resource "azurerm_network_interface" "nic_todo_app" {
  name                = var.nic_name
  location            = var.nic_location
  resource_group_name = var.nic_rg_name

  ip_configuration {
    name = "internal"
    # passing the value through the variable
    # subnet_id                     = var.subnet_id
    subnet_id                     = data.azurerm_subnet.subnets.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id = var.ip_address1 # passing the value through the variable
    public_ip_address_id = data.azurerm_public_ip.pip_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm_todo_app" {
  name                            = var.vm_name
  resource_group_name             = var.nic_rg_name
  location                        = var.nic_location
  size                            = var.vm_size
  admin_username                  = data.azurerm_key_vault_secret.kv_secret_user.value
  #Now from Data block using key vault secret to pass the value on run time
  admin_password = data.azurerm_key_vault_secret.kv_secret_pass.value
  #admin_password                  = var.vm_password # without key vault secrets
  disable_password_authentication = false
  #from implicity dependency also we fetch the attributes but block should be in same file code
  network_interface_ids = [
    azurerm_network_interface.nic_todo_app.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.os_version
  }
}

resource "null_resource" "ngnix" {
  count      = var.install_nginx ? 1 : 0
  depends_on = [azurerm_linux_virtual_machine.vm_todo_app]
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install nginx -y",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]

    connection {
      type     = "ssh"
      user = data.azurerm_key_vault_secret.kv_secret_user.value
      password = data.azurerm_key_vault_secret.kv_secret_pass.value
      # user     = var.vm_username
      # password = var.vm_password
      host     = data.azurerm_public_ip.pip_ip.ip_address
      # host     = var.frontend_ip_address
    }
  }
}




