
#locals for variable's declaration.

locals {
  full_name  = "${var.offer_name}-${var.environment_name}"
  full_name1 = "${var.offer_name}${var.environment_name}"
  default_tags = {
    offername        = var.offer_name
    environment_name = var.environment_name
    Description      = "Resource Terraformed for ${local.full_name}"
    Description1     = "Resource Terraformed for ${local.full_name1}"
    Terraform        = "true"
  }
}


#_________________________________________________________________________________________________________________________________________________________________

# resource group modularaisation

module "azurerm_resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = "rg-tfstatefile-shr-dev-14"
  location            = "France Central"
}
/*
data "azurerm_resource_group" "rg" {
   name     = "rg-tfstatefile-shr-dev-14"
  #  location = "France Central"
}
*/

#_________________________________________________________________________________________________________________________________________________________________
#We are going to use already existing virtual network, we got it with the subscription itself, so we are using this as data.
#Virtual_network

#data "azurerm_virtual_network" "vnet" {
  #name                = "vnet-spoke-digglobalwiserinsightsevl001-prod-fc-001"
  #resource_group_name = "rg-management-prod-fc"
#}

data "azurerm_virtual_network" "vnet" {
  name                = "vnet-spoke-digalzmigrationdit001-prod-fc-001"
  resource_group_name = "rg-management-prod-fc"
}


#_________________________________________________________________________________________________________________________________________________________________

#Subnet
# resource "azurerm_subnet" "subnet_pep" {
#   name                 = "snet-pep-${local.full_name}-01"
#   resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
#   virtual_network_name = data.azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.242.211.0/26"]
#   service_endpoints    = ["Microsoft.ContainerRegistry", "Microsoft.KeyVault", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web", "Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.CognitiveServices", "Microsoft.EventHub", "Microsoft.ServiceBus"]
# }
#data "azurerm_subnet" "subnet_pep" {
  #name                 = "pep-snet"
 # resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
  #virtual_network_name = data.azurerm_virtual_network.vnet.name
#}
data "azurerm_subnet" "subnet_pep" {
  name                 = "sqltest"
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}
# resource "azurerm_subnet" "subnet_asp" {
#   name                 = "snet-asp-${local.full_name}-02"
#   resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
#   virtual_network_name = data.azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.0.224/28"]
#   service_endpoints    = ["Microsoft.ContainerRegistry", "Microsoft.KeyVault", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web", "Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.CognitiveServices", "Microsoft.EventHub", "Microsoft.ServiceBus"]

#   delegation {
#     name = "app_service-delegation"

#     service_delegation {
#       name    = "Microsoft.Web/serverFarms"
#       actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
#     }
#   }
# }

#data "azurerm_subnet" "subnet_asp"  {
 # name                 = "snet-asp-layoutfast-dev-02"
  #resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
  #virtual_network_name = data.azurerm_virtual_network.vnet.name
#}

# resource "azurerm_subnet" "subnet_fsp" {
#   name                 = "snet-fsp-${local.full_name}-03"
#   resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
#   virtual_network_name = data.azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.0.240/28"]
#   service_endpoints    = ["Microsoft.ContainerRegistry", "Microsoft.KeyVault", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web", "Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.CognitiveServices", "Microsoft.EventHub", "Microsoft.ServiceBus"]

#   delegation {
#     name = "app_service-delegation"

#     service_delegation {
#       name    = "Microsoft.Web/serverFarms"
#       actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
#     }
#   }
# }

#data "azurerm_subnet" "subnet_fsp"  {
 # name                 = "snet-fsp-layoutfast-dev-03"
  #resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
  #virtual_network_name = data.azurerm_virtual_network.vnet.name
#}


/*
#_________________________________________________________________________________________________________________________________________________________________
#ASP-LayoutFASTRG-81b3 
#App_Service_Plan
module "azurerm_service_plan" {
  source                   = "./modules/app_service_plan"
  name_service_plan        = "wap-${local.full_name}-01"
  per_site_scaling_enabled = false
 # kind                     = "FunctionApp"
  os_type_service_plan     = "Windows"
  sku_name_service_plan    = "B2"  #change -- Y1,Dynamic
  # worker_count             = 0
  resource_group_name = module.azurerm_resource_group.resource_group_name
  location            = module.azurerm_resource_group.resource_group_location


}



#_________________________________________________________________________________________________________________________________________________________________
#kv-layoutfast
#keyvault
module "key_vault" {
  source                      = "./modules/Key_vault"
  depends_on                  = [data.azurerm_subnet.subnet_pep]
  key_vault_name              = "kv-${local.full_name}-01"
  resource_group_name         = module.azurerm_resource_group.resource_group_name
  location                    = module.azurerm_resource_group.resource_group_location
  user_assigned_identity_name = "${local.full_name}-mgdid-kv-01"
  soft_delete_retention_days  = "90"
  sku_name                    = "standard"
  subnet_id                   = data.azurerm_subnet.subnet_pep.id
  key_permissions = [
    "Get", "List", "Backup", "Create", "Decrypt", "Delete", "Import", "Recover", "Restore", "Update", "Rotate", "GetRotationPolicy", "SetRotationPolicy",
  ]

  secret_permissions = [
    "Get", "List", "Backup", "Delete", "Recover", "Restore", "Set",
  ]

  certificate_permissions = [
    "Get", "Update", "GetIssuers", "Import", "List", "ListIssuers", "Backup", "Create", "Delete", "DeleteIssuers", "ManageContacts", "ManageIssuers", "Recover", "Restore", "SetIssuers",
  ]
  endpoint_name_kv                   = "pvtep-kv-${local.full_name1}-01"
  purge_protection_enabled           = false
  public_network_access_enabled      = false
  enabled_for_disk_encryption        = true
  is_manual_connection               = false
  sub_resource_name                  = ["vault"]
  private_service_connection_name_kv = "pvtsc-kv-${local.full_name1}-01"
  net_acl_default_action             = "Deny"
  net_acl_bypass                     = "AzureServices"
}

*/
#_________________________________________________________________________________________________________________________________________________________________

#functionslayoutfas74f9ae
#storage_account
module "azurerm_storage_account" {
  source                   = "./modules/storage_account"
  depends_on               = [data.azurerm_subnet.subnet_pep]
  storage_account_name     = "sttfstateshrdev15"
resource_group_name      = module.azurerm_resource_group.resource_group_name
location                 = module.azurerm_resource_group.resource_group_location
# resource_group_name      = data.azurerm_resource_group.rg.name
 #location                 = data.azurerm_resource_group.rg.location
  account_replication_type = "LRS"
  account_kind             = "StorageV2" #change--storage
  endpoint_name            = "pvtep-st-${local.full_name}-01"
  service_connection_name  = "pvtsc-st-${local.full_name}-01"
  vnet_name                = data.azurerm_virtual_network.vnet.name
  resource_group_name1     = data.azurerm_virtual_network.vnet.resource_group_name
  snet_name                = data.azurerm_subnet.subnet_pep.name
}
/*
#layoutfastrga77c

module "azurerm_storage_account1" {
  source                   = "./modules/storage_account"
  depends_on               = [data.azurerm_subnet.subnet_pep]
  storage_account_name     = "st${local.full_name1}02"
  resource_group_name      = module.azurerm_resource_group.resource_group_name
  location                 = module.azurerm_resource_group.resource_group_location
  account_replication_type = "LRS"
  account_kind             = "StorageV2" #change--storage
  endpoint_name            = "pvtep-st-${local.full_name}-02"
  service_connection_name  = "pvtsc-st-${local.full_name}-02"
  vnet_name                = data.azurerm_virtual_network.vnet.name
  resource_group_name1     = data.azurerm_virtual_network.vnet.resource_group_name
  snet_name                = data.azurerm_subnet.subnet_pep.name
}


#_________________________________________________________________________________________________________________________________________________________________
#layoutfast-functions
#Function_App


module "azurerm_function_app" {
  source                        = "./modules/function_app"
  functionappsubnet             = data.azurerm_subnet.subnet_fsp.id
  subnet_id                     = data.azurerm_subnet.subnet_pep.id
  appserviceplan_id             = module.azurerm_service_plan.asp_id
  azurerm_function_app_location = module.azurerm_resource_group.resource_group_location
  azurerm_function_app_name     = "func-${local.full_name}-01"
  azurerm_function_app_Rg       = module.azurerm_resource_group.resource_group_name
  storageaccount_name           = module.azurerm_storage_account.storage_name
  private_endpoint_name         = "pvtep-func-${local.full_name1}-01"
  private_sc_name               = "pvtsc-func-${local.full_name1}-01"
  sacc_name                     = module.azurerm_storage_account.storage_name
  sacc_primary_access_key       = module.azurerm_storage_account.storage_primary_access_key
  #connectstring = module.azurerm_storage_account.storage_fs_connection_string

}
# module "azurerm_function_app1" {
#   source                        = "./modules/function_app"
#   functionappsubnet             = data.azurerm_subnet.subnet_fsp.id
#   subnet_id                     = data.azurerm_subnet.subnet_pep.id
#   appserviceplan_id             = module.azurerm_service_plan.asp_id
#   azurerm_function_app_location = module.azurerm_resource_group.resource_group_location
#   azurerm_function_app_name     = "func-${local.full_name1}-01"
#   azurerm_function_app_Rg       = module.azurerm_resource_group.resource_group_name
#   storageaccount_name           = module.azurerm_storage_account.storage_name
#   private_endpoint_name         = "pvtep-func-${local.full_name}-01"
#   private_sc_name               = "pvtsc-func-${local.full_name}-01"
#   sacc_name                     = module.azurerm_storage_account.storage_name
#   sacc_primary_access_key       = module.azurerm_storage_account.storage_primary_access_key
#   #connectstring = module.azurerm_storage_account.storage_fs_connection_string

# }
# module "azurerm_function_app2" {
#   source                        = "./modules/function_app"
#   functionappsubnet             = data.azurerm_subnet.subnet_fsp.id
#   subnet_id                     = data.azurerm_subnet.subnet_pep.id
#   appserviceplan_id             = module.azurerm_service_plan.asp_id
#   azurerm_function_app_location = module.azurerm_resource_group.resource_group_location
#   azurerm_function_app_name     = "func-${local.full_name}-04"
#   azurerm_function_app_Rg       = module.azurerm_resource_group.resource_group_name
#   storageaccount_name           = module.azurerm_storage_account.storage_name
#   private_endpoint_name         = "pvtep-func-${local.full_name1}-04"
#   private_sc_name               = "pvtsc-func-${local.full_name1}-04"
#   sacc_name                     = module.azurerm_storage_account.storage_name
#   sacc_primary_access_key       = module.azurerm_storage_account.storage_primary_access_key
#   #connectstring = module.azurerm_storage_account.storage_fs_connection_string

# }


#_________________________________________________________________________________________________________________________________________________________________
#layoutfast-dev #change loc --east us
module "azurerm_cosmosdb_account" {
  source                                  = "./modules/cosmosdb_account1"
  depends_on                              = [data.azurerm_subnet.subnet_pep]
  rg_location                             = module.azurerm_resource_group.resource_group_location
  rg_name                                 = module.azurerm_resource_group.resource_group_name
  offer_type                              = "Standard"
  db_name                                 = "cosmos-${local.full_name}-01"
  kind                                    = "GlobalDocumentDB"
  consistency_policy_max_interval_in_sec  = 5
  consistency_policy_max_staleness_prefix = 100
  consistency_level                       = "Session"
  subnet_id                               = data.azurerm_subnet.subnet_pep.id
  endpoint_name                           = "pvtep-cosmos-${local.full_name1}-01"
  is_manual_connection                    = false
  sub_resource_name                       = ["Sql"]
  private_service_connection_name         = "pvtsc-cosmos-${local.full_name1}-01"
  geo_loc =  "East US 2"
  failover_prior = 0 
  zone =  false
  backup_type =  "Periodic"
  retention_in_hr =  8
  st_redundancy =  "Geo"
  interval_in_min = 240
}
# module "azurerm_cosmosdb_account2" {
#   source                                  = "./modules/cosmosdb_account1"
#   depends_on                              = [data.azurerm_subnet.subnet_pep]
#   rg_location                             = module.azurerm_resource_group.resource_group_location
#   rg_name                                 = module.azurerm_resource_group.resource_group_name
#   offer_type                              = "Standard"
#   db_name                                 = "cosmos-${local.full_name}-03"
#   kind                                    = "GlobalDocumentDB"
#   consistency_policy_max_interval_in_sec  = 5
#   consistency_policy_max_staleness_prefix = 100
#   consistency_level                       = "Session"
#   subnet_id                               = data.azurerm_subnet.subnet_pep.id
#   endpoint_name                           = "pvtep-cosmos-${local.full_name1}-03"
#   is_manual_connection                    = false
#   sub_resource_name                       = ["Sql"]
#   private_service_connection_name         = "pvtsc-cosmos-${local.full_name1}-03"
# }
#buswayfast-test
module "azurerm_cosmosdb_account1" {
  source                                  = "./modules/cosmosdb_account"
  depends_on                              = [data.azurerm_subnet.subnet_pep]
  rg_location                             = module.azurerm_resource_group.resource_group_location
  rg_name                                 = module.azurerm_resource_group.resource_group_name
  offer_type                              = "Standard"
  db_name                                 = "cosmos-${local.full_name}-02"
  kind                                    = "GlobalDocumentDB"
  consistency_policy_max_interval_in_sec  = 5
  consistency_policy_max_staleness_prefix = 100
  consistency_level                       = "Session"
  subnet_id                               = data.azurerm_subnet.subnet_pep.id
  endpoint_name                           = "pvtep-cosmos-${local.full_name1}-02"
  is_manual_connection                    = false
  sub_resource_name                       = ["Sql"]
  private_service_connection_name         = "pvtsc-cosmos-${local.full_name1}-02"
  geo_loc =  "East US 2"
  failover_prior = 0 
  cap_name =  "EnableServerless"
  zone =  false
  throughput_limit = 4000 
  backup_type =  "Periodic"
  retention_in_hr =  8
  st_redundancy =  "Geo"
  interval_in_min = 240
}

# module "azurerm_cosmosdb_account4" {
#   source                                  = "./modules/cosmosdb_account"
#   depends_on                              = [data.azurerm_subnet.subnet_pep]
#   rg_location                             = module.azurerm_resource_group.resource_group_location
#   rg_name                                 = module.azurerm_resource_group.resource_group_name
#   offer_type                              = "Standard"
#   db_name                                 = "cosmos-${local.full_name}-04"
#   kind                                    = "GlobalDocumentDB"
#   consistency_policy_max_interval_in_sec  = 5
#   consistency_policy_max_staleness_prefix = 100
#   consistency_level                       = "Session"
#   subnet_id                               = data.azurerm_subnet.subnet_pep.id
#   endpoint_name                           = "pvtep-cosmos-${local.full_name1}-04"
#   is_manual_connection                    = false
#   sub_resource_name                       = ["Sql"]
#   private_service_connection_name         = "pvtsc-cosmos-${local.full_name1}-04"
# }
#_________________________________________________________________________________________________________________________________________________________________

module "azurerm_cosmosdb_postgresql_cluster" {
  source                          = "./modules/azurecosmosdbpostgresql"
  rg_location                     = module.azurerm_resource_group.resource_group_location
  rg_name                         = module.azurerm_resource_group.resource_group_name
  node_count                      = 0
  password                        = "Newuser@12345"
  postgresql_name                 = "cospos-${local.full_name}-01"
  stog_quota                      = 131072
  vcore_count                     = 2
  private_service_connection_name = "pvtsc-cospos-${local.full_name1}-01"
  endpoint_name                   = "pvtep-cospos-${local.full_name1}-01"
  is_manual_connection            = false
  sub_resource_name               = ["coordinator"]
  subnet_id                       = data.azurerm_subnet.subnet_pep.id
  mw_dow =  0
  mw_sh =  0
  mw_sm =  0
  version_sql = 15 
  storage_quota_in_mb_node = 524288
  coordinator_server_edi = "GeneralPurpose"  
  node_server_edi = "MemoryOptimized"
  node_vcore = 4 
}
#_________________________________________________________________________________________________________________________________________________________________

#app_service_&_app_service_plan
module "azurerm_windows_web_app" {
  source                          = "./modules/app_service"
  resource_group_name             = module.azurerm_resource_group.resource_group_name
  location                        = module.azurerm_resource_group.resource_group_location
  name_service_plan               = "wap-${local.full_name}-02"
  os_type_service_plan            = "Linux"
  sku_name_service_plan           = "B2"
  private_endpoint_name           = "pvtep-wap-${local.full_name1}-01"
  private_service_connection_name = "pvtsc-wap-${local.full_name1}-01"
  subnet_id1                      = data.azurerm_subnet.subnet_pep.id
  subnet_id                       = data.azurerm_subnet.subnet_asp.id
  is_manual_connection            = false
  windows_web_app_name            = "appc-${local.full_name}-01"
  subresource_names               = ["sites"]
  site_config_always_on           = true
  worker_count                    = 1
  per_site_scaling_enabled        = false
}


module "azurerm_windows_web_app1" {
  source                          = "./modules/app_service1"
  resource_group_name             = module.azurerm_resource_group.resource_group_name
  location                        = module.azurerm_resource_group.resource_group_location
  plan_id                         = module.azurerm_windows_web_app.asp_id
  private_endpoint_name           = "pvtep-wap-${local.full_name1}-02"
  private_service_connection_name = "pvtsc-wap-${local.full_name1}-02"
  subnet_id1                      = data.azurerm_subnet.subnet_pep.id
  subnet_id                       = data.azurerm_subnet.subnet_asp.id
  is_manual_connection            = false
  windows_web_app_name            = "appc-${local.full_name}-02"
  subresource_names               = ["sites"]
  site_config_always_on           = true
  worker_count                    = 1
  per_site_scaling_enabled        = false
}
#_________________________________________________________________________________________________________________________________________________________________
*/
