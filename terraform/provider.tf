terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.92.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}
