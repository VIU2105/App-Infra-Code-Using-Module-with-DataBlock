variable "mysql_database" {
  description = "Name of the MySQL Database"
  type        = string
}

#Data Block is used to 
# variable "sql_server_id" {
#   description = "Name of the MySQL Server"
#   type        = string
  
# }

variable "sql_server" {

  description = "The Data block using sql_server"
  type = string
  
}

variable "rg_name" {
  
  description = "The Data block using resource group"
  type = string
  
}