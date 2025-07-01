output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "userpool_id" {
  value = azurerm_kubernetes_cluster_node_pool.userpool.id
}
