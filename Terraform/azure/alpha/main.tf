resource "azurerm_resource_group" "rg" {
    name = var.resource_group_name
    location = var.location
}


resource "azurerm_kubernetes_cluster" "aks" {
    name = var.aks_cluster_name
    location = var.azurerm_resource_group.rg.location
    resource_group_name = var.azurerm_resource_group.rg.name
    dns_prefix = var.dns_prefix


    default_node_pool {
        name = "default"
        node_count = var.node_count
        vm_size = "Standard_D2_v2"
    }

    identity {
        type = SystemAssigned
    }

    network_profile {
        network_plugin = "azure"
        network_policy = "azure"
        load_balancer_sku = "standard"
        service_cidr = "10.0.1.0/18"
        dns_service_ip = "10.0.1.19"
        docker_bridge_cidr = "172.17.0.1/16"
    }

    role_based_access_controle_enabled = true

    tags = {
        environment = "dev"
    }
}