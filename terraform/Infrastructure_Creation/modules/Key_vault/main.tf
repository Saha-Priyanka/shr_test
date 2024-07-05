
resource "azurerm_user_assigned_identity" "epo-mgd-id" {
  name                = var.user_assigned_identity_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "key_vault" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = var.enabled_for_disk_encryption 
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = var.soft_delete_retention_days
  purge_protection_enabled    = var.purge_protection_enabled 
  public_network_access_enabled = var.public_network_access_enabled 
  sku_name = var.sku_name
  enabled_for_template_deployment = true
enable_rbac_authorization = false
network_acls {
  bypass = var.net_acl_bypass 
  default_action = var.net_acl_default_action 
}

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_user_assigned_identity.epo-mgd-id.principal_id

    certificate_permissions = var.certificate_permissions

    key_permissions = var.key_permissions

    secret_permissions = var.secret_permissions
  }
}

resource "azurerm_private_endpoint" "endpoint" {
  name                = var.endpoint_name_kv 
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  depends_on = [azurerm_key_vault.key_vault  ]

  private_service_connection {
    name                           = var.private_service_connection_name_kv 
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    subresource_names              = var.sub_resource_name  
    is_manual_connection           = var.is_manual_connection 
  }
}

