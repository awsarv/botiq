terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.30.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "9e3495e5-eaf2-435d-b9ef-73318ef8771b"
}

resource "azurerm_resource_group" "demo-rg" {
  name     = "demo-rg"
  location = "East US"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "demo-vn" {
  name                = "demo-network"
  resource_group_name = azurerm_resource_group.demo-rg.name
  location            = azurerm_resource_group.demo-rg.location
  address_space       = ["10.123.0.0/16"]

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "demo-subnet" {
  name                 = "demo-subnet"
  resource_group_name  = azurerm_resource_group.demo-rg.name
  virtual_network_name = azurerm_virtual_network.demo-vn.name
  address_prefixes     = ["10.123.1.0/24"]
}

resource "azurerm_network_security_group" "demo-sg" {
  name                = "demo-sg"
  location            = azurerm_resource_group.demo-rg.location
  resource_group_name = azurerm_resource_group.demo-rg.name

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "demo-sg-rule" {
  name                        = "demo-sg-rule"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.demo-rg.name
  network_security_group_name = azurerm_network_security_group.demo-sg.name
}

resource "azurerm_subnet_network_security_group_association" "demo-sga" {
  subnet_id                 = azurerm_subnet.demo-subnet.id
  network_security_group_id = azurerm_network_security_group.demo-sg.id
}

resource "azurerm_public_ip" "demo-ip" {
  name                = "demo-ip"
  resource_group_name = azurerm_resource_group.demo-rg.name
  location            = azurerm_resource_group.demo-rg.location
  allocation_method   = "Static"

  tags = {
    environment = "dev"
  }
}


resource "azurerm_kubernetes_cluster" "demo-aks" {
  name                = "demo-aks"
  location            = azurerm_resource_group.demo-rg.location
  resource_group_name = azurerm_resource_group.demo-rg.name
  dns_prefix          = "demoaks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "dev"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.demo-aks.kube_config_raw
  sensitive = true
}
