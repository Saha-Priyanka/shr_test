  terraform {
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "3.78.0"
      }
      # azapi = {
      #   source  = "Azure/azapi"
      #   version = "0.4.0"
      # }
    }
  }
 
  provider "azurerm" {
    skip_provider_registration = "true"
    features {}
  }
  # provider "azapi" {
  #   skip_provider_registration = "true"
    
  # }



