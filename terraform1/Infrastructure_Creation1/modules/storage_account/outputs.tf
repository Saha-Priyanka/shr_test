output "storage_id" {
  value = data.azurerm_storage_account.storage.id
}
output "storage_name" {
  value = data.azurerm_storage_account.storage.name
  
}
output "storage_primary_access_key" {
  value = data.azurerm_storage_account.storage.primary_access_key
}

output "storage_fs_connection_string" {
  value = data.azurerm_storage_account.storage.primary_connection_string
}
