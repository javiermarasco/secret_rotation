resource "azurerm_storage_account" "storage" {
  name                     = "vaultbackendkeyrotation"
  resource_group_name      = var.RG_Name
  location                 = var.RG_Location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
