terraform {
    required_version = ">=1.11.0"

    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "=>4.30"
        }
    }
}


provider "azurerm" {
    features {}
    use_cli = true
}