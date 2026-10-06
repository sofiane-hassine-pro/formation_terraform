terraform {
  backend "azurerm" {
    resource_group_name  = "rg-sp1-t--azu-formation-terraform-octobre26-txt"
    storage_account_name = "tfstatesa10"
    container_name       = "formation"
    key                  = "sofiane1.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0, < 5.0"
    }
  }
  required_version = ">= 1.0"
}
provider "azurerm" {
  features {}
}

