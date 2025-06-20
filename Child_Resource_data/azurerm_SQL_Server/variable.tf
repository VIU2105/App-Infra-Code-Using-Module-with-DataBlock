variable "sql_server_name" {
  description = "Name of the SQL Server"
  type        = string
  
}
variable "rg_name" {
  description = "Resource Group Name for the SQL Server"
  type        = string
  
}
variable "sql_server_location" {
  description = "Location of the SQL Server"
  type        = string
  
}   
variable "login_sql_server" {
  description = "Login for the SQL Server"
  type        = string
  
}   
variable "password_sql_server" {
  description = "Password for the SQL Server"
  type        = string
  sensitive   = true
}