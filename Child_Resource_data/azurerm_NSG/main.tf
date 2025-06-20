# data "azurerm_network_interface" "nic" {
#   name                = var.nic_name
#   resource_group_name = var.resource_group_name
# }

data "azurerm_subnet" "fr_subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_network_security_group" "frontend_vm_nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_attach" {
  subnet_id                 = data.azurerm_subnet.fr_subnet.id
  network_security_group_id = azurerm_network_security_group.frontend_vm_nsg.id
}

# resource "azurerm_network_interface_security_group_association" "nic_nsg_attach" {
#   # network_interface_id      = var.nic_id #we are passing value through variable
#   # depends_on = [ data.azurerm_network_interface.nic ]
#   network_interface_id      = data.azurerm_network_interface.nic.id # Now we are using data block 
#   network_security_group_id = azurerm_network_security_group.frontend_vm_nsg.id
# }

resource "azurerm_network_security_rule" "ssh_rule" {
     depends_on = [ azurerm_subnet_network_security_group_association.subnet_nsg_attach ]
   # depends_on = [ azurerm_network_interface_security_group_association.nic_nsg_attach ]
  name                        = "Allow-SSH"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.nsg_name
}

resource "azurerm_network_security_rule" "http_rule" {
  
     depends_on = [ azurerm_subnet_network_security_group_association.subnet_nsg_attach ]
    # depends_on = [ azurerm_network_interface_security_group_association.nic_nsg_attach ]
  name                        = "Allow-HTTP"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.nsg_name
}



