terraform {
  backend "azurerm" {
    resource_group_name  = "demo-rg"
    storage_account_name = "botiqtfstate"        # Create this if not already
    container_name       = "tfstate"
    key                  = "argo-aks.tfstate"
  }
}
