output "kube_config_raw" {
  description = "Raw kubeconfig file content for automation"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.aks.oidc_issuer_url
}

output "selected_kubernetes_version" {
  value = local.selected_version
}
