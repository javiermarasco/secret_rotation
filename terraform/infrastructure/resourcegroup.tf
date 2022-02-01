resource "azurerm_resource_group" "resource_group" {
  name     = var.RG_Name
  location = var.RG_Location
}
