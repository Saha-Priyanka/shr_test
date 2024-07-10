
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

terraform {
    # required_version = "0.14.8"
    backend "azurerm" {
        resource_group_name = "rg-layfast-ppr-14"
        storage_account_name = "st${local.full_name1}01" #"stlayfastppr01"
        container_name = "contlayfastppr01"
        key = "pprterraform.tfstate"
       # arm_subscription_id = "793729a4-a745-4e4f-8b8d-88bda288a86a"
       # arm_tenant_id = "1e9cc706-c3fd-4b8c-9dbd-a073e7384b56"
        
    }
} 


#_________________________________________________________________________________________________________________________________________________________________

 # resource group modularaisation
 module "azurerm_resource_group" {
   source              = "./modules/resource_group"
  resource_group_name = "rg-${local.full_name}-01"
   location            = "France Central"
 }

#data "azurerm_resource_group" "rg" {
  #name = "rg-github-shr-01"
#}

#_________________________________________________________________________________________________________________________________________________________________
#We are going to use already existing virtual network, we got it with the subscription itself, so we are using this as data.
#Virtual_network
/*
data "azurerm_virtual_network" "vnet" {
  name                = "vnet-spoke-digglobalwiserinsightsevl001-prod-fc-001"
  resource_group_name = "rg-management-prod-fc"
}*/
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
/*
data "azurerm_subnet" "subnet_pep" {
  name                 = "pep-snet"
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}
*/
data "azurerm_subnet" "subnet_pep" {
  name                 = "sqltest"
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

#_________________________________________________________________________________________________________________________________________________________________
#kv-layoutfast
#keyvault
module "key_vault" {
  source                      = "./modules/Key_vault"
  depends_on                  = [data.azurerm_subnet.subnet_pep]
  key_vault_name              = "kv-${local.full_name}-25"
   resource_group_name         = module.azurerm_resource_group.resource_group_name
  location                    = module.azurerm_resource_group.resource_group_location 
 # resource_group_name =  data.azurerm_resource_group.rg.name 
 # location = data.azurerm_resource_group.rg.location
  user_assigned_identity_name = "${local.full_name}-mgdid-kv-25"
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
  endpoint_name_kv                   = "pvtep-kv-${local.full_name}-25"
  purge_protection_enabled           = false
  public_network_access_enabled      = false
  enabled_for_disk_encryption        = true
  is_manual_connection               = false
  sub_resource_name                  = ["vault"]
  private_service_connection_name_kv = "pvtsc-kv-${local.full_name}-25"
  net_acl_default_action             = "Deny"
  net_acl_bypass                     = "AzureServices"
}

