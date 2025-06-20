
variable "pip_name" {
  description = "The name of the public IP"
  type        = string
  
}

variable "pip_rg" {
  description = "The name of the resource group where the public IP is located"
  type        = string
  
}

variable "pip_location" {
  description = "The location of the public IP"
  type        = string

}