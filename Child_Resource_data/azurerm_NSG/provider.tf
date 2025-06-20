
variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
  
}

variable "location" {
  description = "Location of the Network Security Group"
  type        = string
  
}

variable "resource_group_name" {
  description = "Resource Group Name for the Network Security Group"
  type        = string  
  
}


# variable "nic_id" {
#   description = "The ID of the network interface to associate with the NSG"
#   type        = string
  
# }

# variable "nic_name" {
#   description = "Passing NIC Name value in Data Block"
#   type = string
  
# }

variable "vnet_name" {
  description = "Passing Vnet Name value in Data Block as NSG at subnet level"
  type = string
  
}

variable "subnet_name" {
  description = "Passing Vnet Name value in Data Block as NSG at subnet level"
  type = string
  
}