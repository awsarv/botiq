resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "aks_vnet" {
  name                = "${var.aks_name}-vnet"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "${var.aks_name}-subnet"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = var.aks_dns_prefix

  default_node_pool {
    name            = "agentpool"
    node_count      = var.agentpool_node_count
    vm_size         = var.agentpool_vm_size
    vnet_subnet_id  = azurerm_subnet.aks_subnet.id
    os_disk_size_gb = 30
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    dns_service_ip = "10.10.2.10"
    service_cidr   = "10.10.2.0/24"
  }

  tags = {
    Environment = "Demo"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  name                  = "userpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.userpool_vm_size
  node_count            = var.userpool_node_count
  vnet_subnet_id        = azurerm_subnet.aks_subnet.id
  mode                  = "User"
  os_disk_size_gb       = 30
  orchestrator_version  = azurerm_kubernetes_cluster.aks.kubernetes_version
}