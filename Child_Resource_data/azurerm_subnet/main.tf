resource "azurerm_subnet" "subnet_todo_app" {
    name                 = var.subnet_name
    resource_group_name  = var.subnet_rg_name
    virtual_network_name = var.vnet_name
    address_prefixes     = var.subnet_address_prefixes
}
