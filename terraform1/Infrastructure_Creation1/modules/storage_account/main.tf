/*
# data "azurerm_virtual_network" "vnet" {
#   name                = var.vnet_name
#   resource_group_name = var.resource_group_name1
# }

# data "azurerm_subnet" "snet"{
#    name = var.snet_name
#   resource_group_name = data.azurerm_virtual_network.vnet.resource_group_name
#   virtual_network_name = data.azurerm_virtual_network.vnet.name
# }
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  # enable_https_traffic_only       = true
  # public_network_access_enabled   = false
  # cross_tenant_replication_enabled = false
  # allow_nested_items_to_be_public = false


  
  #   network_rules {
  #     default_action             = "Deny"
  #     bypass                     = ["None"]
  #     virtual_network_subnet_ids = [data.azurerm_subnet.snet.id]
  # }
}

# resource "azurerm_private_endpoint" "endpoint" {
#   depends_on = [ azurerm_storage_account.storage ]
#   name                = var.endpoint_name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = data.azurerm_subnet.snet.id

#   private_service_connection {
#     name                           = var.service_connection_name
#     private_connection_resource_id = azurerm_storage_account.storage.id 
#     subresource_names              = ["blob"]
#     is_manual_connection           = false
#   }
# }


resource "azurerm_storage_container" "container" {
depends_on = [ azurerm_storage_account.storage ]
  name                  = "tfstate-shr-dev-07"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"

}
*/







 data "azurerm_virtual_network" "vnet" {
   name                = var.vnet_name
   resource_group_name = var.resource_group_name1
 }

 data "azurerm_subnet" "snet"{
    name = var.snet_name
   resource_group_name = data.azurerm_virtual_network.vnet.resource_group_name
   virtual_network_name = data.azurerm_virtual_network.vnet.name
 }
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
   enable_https_traffic_only       = true
   public_network_access_enabled   = false
   cross_tenant_replication_enabled = false
 allow_nested_items_to_be_public = false


  
     network_rules {
       default_action             = "Deny"
       #bypass                     = ["AzureServices", "Logging"]
       bypass                     = ["None"]
       virtual_network_subnet_ids = [data.azurerm_subnet.snet.id]
       #ip_rules = ["136.226.254.83"]
   }
}

 resource "azurerm_private_endpoint" "endpoint" {

depends_on = [ azurerm_storage_account.storage ]
  name                = var.endpoint_name
   location            = var.location
   resource_group_name = var.resource_group_name
   subnet_id           = data.azurerm_subnet.snet.id

   private_service_connection {
     name                           = var.service_connection_name
     private_connection_resource_id = azurerm_storage_account.storage.id 
     subresource_names              = ["blob"]
     is_manual_connection           = false
   }
 }

# This resource will destroy (potentially immediately) after null_resource.next
resource "null_resource" "previous" {
  depends_on = [ azurerm_private_endpoint.endpoint]
}


resource "time_sleep" "wait_960_sec" {
  depends_on = [null_resource.previous]

  create_duration = "960s"
}

# This resource will create (at least) 960 seconds after null_resource.previous
resource "null_resource" "next" {
  depends_on = [time_sleep.wait_960_sec]
}



/*
resource "azurerm_storage_container" "container" {
  # depends_on = [ time_sleep.wait_120_sec ]
  name                  = "tfstate-shr-dev-09"
  storage_account_name  = data.azurerm_storage_account.storage.name
  container_access_type = "private"

}



data "azurerm_storage_account" "storage" {
  name                     = "sttfstateshrdev11"
  resource_group_name      = "rg-tfstatefile-shr-dev-11"
 
}



resource "azurerm_storage_container" "container" {
  # depends_on = [ time_sleep.wait_120_sec ]
  name                  = "tfstate-shr-dev-11"
  storage_account_name  = data.azurerm_storage_account.storage.name
  container_access_type = "private"

}
*/
