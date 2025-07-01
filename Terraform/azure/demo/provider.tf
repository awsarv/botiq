terraform {
  required_version = ">=1.3.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.4.0"
    }
    random = {
      source = "hashicorp/random"
    }
    time = {
      source = "hashicorp/time"
    }
  }

  backend "azurerm" {
    resource_group_name  = "demo"
    storage_account_name = "botiqtfbackup"
    container_name       = "tfstate"
    key                  = "aks-demo.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "random" {}

provider "time" {}
