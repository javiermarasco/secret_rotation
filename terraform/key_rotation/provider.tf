terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.92.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.2.1"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "terraformjavierkey"
    container_name       = "tfstate"
    key                  = "key.rotation.tfstate"
  }
}

provider "azurerm" {
  features {}
}
provider "vault" {
}
