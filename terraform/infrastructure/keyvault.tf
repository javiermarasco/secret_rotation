data "azurerm_client_config" "current" {}

# Creamos una keyvault donde vamos a guardar la key para hacer el unseal de vault
resource "azurerm_key_vault" "keyvault" {
  name                        = var.vault_key_name
  location                    = var.RG_Location
  resource_group_name         = var.RG_Name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
  depends_on = [
    azurerm_resource_group.resource_group
  ]
}

# Access policy para el service principal que realiza el unseal de vault, con los permisos necesarios para poder usar la key
resource "azurerm_key_vault_access_policy" "keyvault_accesspolicy_unseal" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azuread_service_principal.seviceprincipal_unseal.object_id

  key_permissions = [
    "get", "wrapKey", "unwrapKey"
  ]
  depends_on = [
    azurerm_key_vault.keyvault
  ]
}

# Access policy para el build agent que crea la key de unseal, con los permisos para poder manejar la key (que la tiene que crear) y en secrets para poder manejar secrets
resource "azurerm_key_vault_access_policy" "keyvault_accesspolicy_pipeline_agent" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey"
  ]
  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set"
  ]
  depends_on = [
    azurerm_key_vault.keyvault
  ]
}

# Crear key para el unseal del vault
resource "azurerm_key_vault_key" "vault_unseal_key" {
  name         = "vault-autounseal-key"
  key_vault_id = azurerm_key_vault.keyvault.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
  depends_on = [
    azurerm_key_vault.keyvault,
    azurerm_key_vault_access_policy.keyvault_accesspolicy_pipeline_agent
  ]
}

# Crear como secret el secret del SPN usado para el unseal de vault
# este valor lo vamos a necesitar para configurar el chart de vault

resource "azurerm_key_vault_secret" "spn_vault_secret" {
  name         = "spn-vault-secret"
  key_vault_id = azurerm_key_vault.keyvault.id
  value        = azuread_service_principal_password.seviceprincipal_unseal_password.value
  depends_on = [
    azurerm_key_vault.keyvault,
    azurerm_key_vault_access_policy.keyvault_accesspolicy_pipeline_agent
  ]
}
