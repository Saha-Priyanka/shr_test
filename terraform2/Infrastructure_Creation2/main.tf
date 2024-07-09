
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
/*
module "azurerm_resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = "rg-tfstatefile-shr-dev-11"
  location            = "France Central"
}
*/

data "azurerm_resource_group" "rg" {
   name     = "rg-${local.full_name}-14"
  #  location = "France Central"
}


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




#_________________________________________________________________________________________________________________________________________________________________

data "azurerm_storage_account" "storage" {
  name                     = "st${local.full_name1}01"
  resource_group_name      = data.azurerm_resource_group.rg.name
 
}

#storage_account_container
module "azurerm_container" {
source                   = "./modules/container"
 container_name = "cont${local.full_name1}01" #contlayfastdev01
  storage_account_name     = data.azurerm_storage_account.storage.name
#  resource_group_name      = module.azurerm_resource_group.resource_group_name
 resource_group_name      = data.azurerm_resource_group.rg.name
access_type= "private"
}
