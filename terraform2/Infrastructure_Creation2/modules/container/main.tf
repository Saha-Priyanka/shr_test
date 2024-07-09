


data "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = "rg-tfstatefile-shr-dev-14"
 
}



resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_name  = data.azurerm_storage_account.storage.name
  container_access_type = "private"

}

