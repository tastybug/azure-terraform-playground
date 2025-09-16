terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.0"
    }
  }
  backend "azurerm" {
    # these have been created manually
    container_name       = "azure-terraform-playground"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}