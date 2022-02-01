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
    key                  = "infrastructure.tfstate"
  }
}

provider "azurerm" {
  features {}
}
