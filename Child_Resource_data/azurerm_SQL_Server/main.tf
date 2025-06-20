resource "azurerm_mssql_server" "sql_server_todo" {
  name                         = var.sql_server_name
  resource_group_name          = var.rg_name
  location                     = var.sql_server_location
  version                      = "12.0"
  administrator_login          = var.login_sql_server
  administrator_login_password = var.password_sql_server
}

