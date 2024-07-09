terraform {
    # required_version = "0.14.8"
    backend "azurerm" {
        resource_group_name = "rg-tfstatefile-shr-dev-14"
        storage_account_name = "sttfstateshrdev20"
        container_name = "tfstate-shr-dev-20"
        key = "terraform.tfstate"
       # arm_subscription_id = "793729a4-a745-4e4f-8b8d-88bda288a86a"
       # arm_tenant_id = "1e9cc706-c3fd-4b8c-9dbd-a073e7384b56"
        
    }
} 
