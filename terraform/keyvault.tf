data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                        = "vault-unseal-kv-uni"
  location                    = var.RG_Location
  resource_group_name         = var.RG_Name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List"
    ]

  }
}


resource "azurerm_key_vault_access_policy" "keyvault_accesspolicy" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azuread_application.application.application_id

  key_permissions = [
    "Get", "List", "Create", "Delete"
  ]
  depends_on = [
    azurerm_key_vault.keyvault,
    azuread_application.application
  ]
}
