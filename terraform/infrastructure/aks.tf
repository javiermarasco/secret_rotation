resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.AKS_Name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  dns_prefix          = "aksrotation"
  default_node_pool {
    name       = "nodepool1"
    vm_size    = "Standard_A2_v2"
    node_count = 1

  }
  identity {
    type = "SystemAssigned"
  }
  depends_on = [
    azurerm_resource_group.resource_group
  ]
}