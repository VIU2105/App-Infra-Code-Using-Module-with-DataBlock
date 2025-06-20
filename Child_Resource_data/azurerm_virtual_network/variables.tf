variable "vnet_rg_name" {
  description = "The name of the resource group"
  type        = string
  
}
variable "vnet_name" {
    description = "The name of the virtual network"
    type        = string
}
variable "vnet_location" {
    description = "The location of the virtual network"
    type        = string
}
variable "address_space" {
    description = "The address space of the virtual network"
    type        = list(string)
}