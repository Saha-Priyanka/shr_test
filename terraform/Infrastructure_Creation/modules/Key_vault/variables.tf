variable "key_vault_name" {
  type = string
}

variable "resource_group_name" {
  type    = string
 
}
 
variable "location" {
  type    = string
 
}

variable "soft_delete_retention_days" {
  type = string
}

variable "sku_name" {
  type = string
}



variable "user_assigned_identity_name" {
  type = string
}

variable "subnet_id" {
  type = string
}
variable "certificate_permissions" {
  type    = list(string)
}
variable "key_permissions" {
  type    = list(string)
}
variable "secret_permissions" {
  type    = list(string)
}
variable "enabled_for_disk_encryption" {
  type    = bool
}
variable "public_network_access_enabled" {
  type    = bool
}
variable "purge_protection_enabled" {
  type    = bool
}
variable "endpoint_name_kv" {
  type    = string
}
variable "private_service_connection_name_kv" {
  type    = string
}
variable "sub_resource_name" {
  type    = list
}
variable "is_manual_connection" {
  type    = bool
}
variable "net_acl_bypass" {
  type    = string
}
variable "net_acl_default_action" {
  type    = string
}