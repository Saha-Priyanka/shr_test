terraform {
    # required_version = "0.14.8"
    backend "azurerm" {
        resource_group_name = "__rg_name__"      #"rg-layfast-ppr-14"
        storage_account_name = "__storage_acc_name__"      #"stlayfastppr01"  
        container_name = "__cont_name__"     #"contlayfastppr01"
        key = "__tfstate_file__"     #"pprterraform.tfstate"
       # arm_subscription_id = "793729a4-a745-4e4f-8b8d-88bda288a86a"
       # arm_tenant_id = "1e9cc706-c3fd-4b8c-9dbd-a073e7384b56"
        
    }
} 


