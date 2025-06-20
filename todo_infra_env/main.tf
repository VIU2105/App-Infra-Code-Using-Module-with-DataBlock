module "resource_group" {
  source      = "../Child_Resource_data/azurerm_resource_group"
  rg_name     = "rg_todo_app"
  rg_location = "centralindia"
}

module "virtual_network" {
  depends_on = [ module.resource_group ]
  source        = "../Child_Resource_data/azurerm_virtual_network"
  vnet_rg_name  = "rg_todo_app"
  vnet_name     = "vnet_todo_app"
  vnet_location = "centralindia"
  address_space = ["22.0.0.0/16"]
}

# Dard 1- Do bar hum module call kar raha hai for Subnet create karne k liya
module "frontend-subnet" {
  depends_on = [ module.virtual_network ]
  source                  = "../Child_Resource_data/azurerm_subnet"
  subnet_rg_name          = "rg_todo_app"
  vnet_name               = "vnet_todo_app"
  subnet_name             = "frontend-subnet"
  subnet_address_prefixes = ["22.0.0.0/24"]
}

module "backend-subnet" {
  depends_on = [ module.virtual_network ]
  source                  = "../Child_Resource_data/azurerm_subnet"
  subnet_rg_name          = "rg_todo_app"
  vnet_name               = "vnet_todo_app"
  subnet_name             = "backend-subnet"
  subnet_address_prefixes = ["22.0.1.0/24"]
}

module "pip_frontend" {
  depends_on = [ module.resource_group ]
  source       = "../Child_Resource_data/azurerm_pip"
  pip_name     = "ip_frontend"
  pip_location = "centralindia"
  pip_rg       = "rg_todo_app"

}

# output "vm_public_ip" {
#   value = module.pip_frontend.frontend_ip_add
# }

module "pip_backend" {
  depends_on = [ module.resource_group ]
  source       = "../Child_Resource_data/azurerm_pip"
  pip_name     = "ip_backend"
  pip_location = "centralindia"
  pip_rg       = "rg_todo_app"

}

module "frontend_vm" {
  depends_on = [ module.frontend-subnet,module.key_valut_secret_username, module.key_vault_secret_password ]
  source = "../Child_Resource_data/azurerm_virtual_machine"
  nic_name = "frontend-nic"
  nic_location = "centralindia"
  nic_rg_name = "rg_todo_app"
  #AB hum data 
  #subnet_id = "/subscriptions/1212a59c-637f-45eb-8b74-8032483be797/resourceGroups/rg_todo_app/providers/Microsoft.Network/virtualNetworks/vnet_todo_app/subnets/frontend-subnet"
  vnet_name = "vnet_todo_app"
  subnet_name = "frontend-subnet"
  vm_name = "frontend-vm-todo-app"
  vm_size = "Standard_B1s"
  # User id and Password hardcoded hai , secret scanning tool fail kr diya hai trufflehog
  
  # vm_username = "adminuser"
  # vm_password = "Admin@123456"
  publisher = "Canonical"
  offer = "0001-com-ubuntu-server-jammy"
  sku = "22_04-lts"
  os_version = "latest"
  # Public IP address hardcoded hai 
  #Data block se value pick kr reh hai to ip_address1 define nahi krne
  #ip_address1 = "/subscriptions/1212a59c-637f-45eb-8b74-8032483be797/resourceGroups/rg_todo_app/providers/Microsoft.Network/publicIPAddresses/ip_frontend"
  name_of_public_ip = "ip_frontend"
  #Use the Data block to revert the ip_address 
  #frontend_ip_address = module.pip_frontend.frontend_ip_add # This used when we install nginx over VM through prvisioner
  install_nginx = true #count loop condition 
   kv_secret_username = "vm-username" 
  kv_secret_pass = "vm-password"
  key_vault_name = "todoapptijori1"
  
}

module "backend_vm" {
  depends_on = [ module.backend-subnet ,module.key_valut_secret_username, module.key_vault_secret_password]
  source = "../Child_Resource_data/azurerm_virtual_machine"
  nic_name = "backend-nic"
  nic_location = "centralindia"
  nic_rg_name = "rg_todo_app"
  #Data block se value pick kr reh hai to subnet_id define nahi krne
  #subnet_id = "/subscriptions/1212a59c-637f-45eb-8b74-8032483be797/resourceGroups/rg_todo_app/providers/Microsoft.Network/virtualNetworks/vnet_todo_app/subnets/backend-subnet"
  vnet_name = "vnet_todo_app"
  subnet_name = "backend-subnet"
  vm_name = "backend-vm-todo-app"
  vm_size = "Standard_B1s"
  #below both value pass through key vault secret through data block 
  # vm_username = "adminuser"
  # vm_password = "Admin@123456"
  publisher = "Canonical"
  offer = "0001-com-ubuntu-server-focal"
  sku = "20_04-lts"
  os_version = "latest"
   # Public IP address hardcoded hai 
  #Data block se value pick kr reh hai to ip_address1 define nahi krne
  #ip_address1 = "/subscriptions/1212a59c-637f-45eb-8b74-8032483be797/resourceGroups/rg_todo_app/providers/Microsoft.Network/publicIPAddresses/ip_backend"
  name_of_public_ip = "ip_backend"
  #Old Method without where we use the this method
  #Use the Data block to revert the ip_address 
  #frontend_ip_address = module.pip_frontend.frontend_ip_add # This used when we install nginx over VM through prvisioner
  install_nginx = false #count loop condition 
  kv_secret_username = "vm-username" 
  kv_secret_pass = "vm-password"
  key_vault_name = "todoapptijori1"
}

# module "sql_server" {
#   depends_on = [ module.resource_group ]
#   source = "../Child_Resource_data/azurerm_SQL_Server"
#   sql_server_name = "todo-app-db-server"
#   sql_server_location = "centralindia"
#   rg_name = "rg_todo_app"
#   login_sql_server = "dbadmin"
#   password_sql_server = "db@123456789"
# }

# module "sql_database" {
#   depends_on = [ module.sql_server ]
#   source = "../Child_Resource_data/azurerm_SQL_Database"
#   mysql_database = "todoappdatabase007"
#   sql_server = "todo-app-db-server"
#   rg_name = "rg_todo_app"
#   #We are using data block to get the mssql_sever_id
#   #sql_server_id = "/subscriptions/1212a59c-637f-45eb-8b74-8032483be797/resourceGroups/rg_todo_app/providers/Microsoft.Sql/servers/todo-app-db-server"
# }

module "nsg_frontend" {
  depends_on = [ module.frontend-subnet]
  source = "../Child_Resource_data/azurerm_NSG"
  nsg_name = "frontend_vm_nsg"
  location = "centralindia"
  resource_group_name = "rg_todo_app"
  vnet_name= "vnet_todo_app"
  subnet_name = "frontend-subnet"
  #Not required as we are putting the NSG at SUbnet level
  # nic_name = "frontend-nic"
  # nic_id = "/subscriptions/1212a59c-637f-45eb-8b74-8032483be797/resourceGroups/rg_todo_app/providers/Microsoft.Network/networkInterfaces/frontend-nic"
}

module "key_vault" {
  depends_on = [ module.resource_group ]
  source = "../Child_Resource_data/azurerm_key_vault"
  kv_location = "centralindia"
  kv_name = "todoapptijori1"
  resource_group_name = "rg_todo_app"

}

module "key_valut_secret_username" {
  depends_on = [ module.key_vault ]
  source = "../Child_Resource_data/azurerm_key_vault_secret"
  secret_name = "vm-username"
  secret_value = "adminuser"
  kv_name = "todoapptijori1"
  resource_group_name = "rg_todo_app"

}

module "key_vault_secret_password" {
  depends_on = [ module.key_vault ]
  source = "../Child_Resource_data/azurerm_key_vault_secret"
  secret_name = "vm-password"
  secret_value = "Admin@123456"
  kv_name = "todoapptijori1"
  resource_group_name = "rg_todo_app"

}