data "azurerm_client_config" "todo_app" {
}

# resource "azurerm_role_assignment" "keyvault_secrets_user" {
#   scope                = azurerm_key_vault.todo_app_kv.id
#   role_definition_name = "Key Vault Secrets User"   # ya "Key Vault Administrator"
#   principal_id         = data.azurerm_client_config.todo_app.object_id
# }
resource "azurerm_key_vault" "todo_app_kv" {
  name                        = var.kv_name
  location                    = var.kv_location
  resource_group_name         = var.resource_group_name 
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.todo_app.tenant_id
  soft_delete_retention_days  = 7
  sku_name = "standard"
  # 👇 Ye line batati hai ki RBAC model use hoga
   purge_protection_enabled    = false
#   soft_delete_enabled         = true # this option is used in azurerm provider version for below 2.32 
  enable_rbac_authorization   = true   # 🔥 This is the key line!

# if we enable below block it will consider Vault access policy model 
#   access_policy {
#     tenant_id = data.azurerm_client_config.current.tenant_id
#     object_id = data.azurerm_client_config.current.object_id

#     key_permissions = [
#       "Get",
#     ]

#     secret_permissions = [
#       "Get",
#     ]

#     storage_permissions = [
#       "Get",
#     ]
#   }
}





