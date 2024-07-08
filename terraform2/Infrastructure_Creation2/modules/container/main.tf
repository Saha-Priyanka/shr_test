


data "azurerm_storage_account" "storage" {
  name                     = "sttfstateshrdev19"
  resource_group_name      = "rg-tfstatefile-shr-dev-14"
 
}



resource "azurerm_storage_container" "container" {
  name                  = "tfstate-shr-dev-19"
  storage_account_name  = data.azurerm_storage_account.storage.name
  container_access_type = "private"

}

