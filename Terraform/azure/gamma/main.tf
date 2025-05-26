locals {
  settings = var.settings
  aks_subnet_id = azurerm_subnet.aks_subnet.id
}

data "azurerm_kubernetes_service_versions" "available_versions" {
  location       = local.settings.location
  version_prefix = local.settings.min_kubernetes_version
}

locals {
  selected_version = (
    data.azurerm_kubernetes_service_versions.available_versions.latest_version != null &&
    data.azurerm_kubernetes_service_versions.available_versions.latest_version != "0.0.0"
  ) ? data.azurerm_kubernetes_service_versions.available_versions.latest_version : "1.28.101"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = local.settings.aks_name
  location            = local.settings.location
  resource_group_name = local.settings.resource_group_name
  kubernetes_version  = local.selected_version
  dns_prefix          = local.settings.dns_prefix

  default_node_pool {
    name                 = local.settings.core_pool_name
    vm_size              = local.settings.core_pool_vm_size
    node_count           = 1
    auto_scaling_enabled = local.settings.enable_auto_scaling
    min_count            = local.settings.core_pool_min_node_count
    max_count            = local.settings.core_pool_max_node_count
    os_disk_size_gb      = local.settings.core_pool_disk_size
    os_disk_type         = local.settings.core_pool_disk_type
    vnet_subnet_id       = local.aks_subnet_id
    tags                 = local.settings.tags
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    service_cidr      = "10.0.0.0/16"
    dns_service_ip    = "10.0.0.10"
  }


  oidc_issuer_enabled = true

  tags = merge(local.settings.tags, {
    environment = "customer"
  })

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
      default_node_pool[0].upgrade_settings
    ]
  }
}

#resource "azurerm_kubernetes_cluster_node_pool" "user_pool" {
#  count                 = local.settings.user_pool_enable ? 1 : 0
#  name                  = local.settings.user_pool_name
#  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
#  vm_size               = local.settings.user_pool_vm_size
#  node_count            = 1
#  auto_scaling_enabled  = local.settings.enable_auto_scaling
#  min_count             = local.settings.user_pool_min_node_count
#  max_count             = local.settings.user_pool_max_node_count
#  os_disk_size_gb       = local.settings.user_pool_disk_size
#  os_disk_type          = local.settings.user_pool_disk_type
#  vnet_subnet_id        = local.aks_subnet_id
#  mode                  = "User"

#  node_labels = {
#    role = "argo-workloads"
#  }

#  tags = local.settings.tags

#  lifecycle {
#    ignore_changes = [node_count]
#  }
#}

resource "azurerm_virtual_network" "aks_vnet" {
  name                = "argo-vnet"
  address_space       = ["10.10.0.0/16"]
  location            = local.settings.location
  resource_group_name = local.settings.resource_group_name

  tags = {
    environment = "networking"
  }
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_virtual_network.aks_vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}


