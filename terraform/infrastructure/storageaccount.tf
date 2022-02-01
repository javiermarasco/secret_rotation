# Storage account para backend de vault
resource "azurerm_storage_account" "storage" {
  name                     = "vaultbackendkeyrotation"
  resource_group_name      = var.RG_Name
  location                 = var.RG_Location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  depends_on = [
    azurerm_resource_group.resource_group
  ]
}

# Container para el backend de vault

resource "azurerm_storage_container" "vault_backend_container" {
  name                  = "vault-container"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}
