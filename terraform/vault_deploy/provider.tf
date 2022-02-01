terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.92.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "terraformjavierkey"
    container_name       = "tfstate"
    key                  = "vault.deploy.tfstate"
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

variable "aks_name" {}

variable "aks_resource_group_name" {}

data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  resource_group_name = var.aks_resource_group_name
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)

  }
}
provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.aks.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}
