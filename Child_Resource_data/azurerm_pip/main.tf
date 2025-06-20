resource "azurerm_public_ip" "pip_todo_app" {
  name                = var.pip_name
  resource_group_name = var.pip_rg
  location            = var.pip_location
  allocation_method   = "Static"
}

output "frontend_ip_add" {

  value =azurerm_public_ip.pip_todo_app.ip_address
  
}