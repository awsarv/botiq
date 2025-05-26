settings = {
  subscription_id       = "9e3495e5-eaf2-435d-b9ef-73318ef8771b"
  aks_name              = "argo-aks"
  dns_prefix            = "argoaks"
  location              = "East US"
  resource_group_name   = "demo-rg"
  min_kubernetes_version = "1.29"
  enable_auto_scaling   = true

  core_pool_name         = "core"
  core_pool_vm_size      = "Standard_D2s_v3"
  core_pool_min_node_count = 1
  core_pool_max_node_count = 2
  core_pool_disk_size    = 30
  core_pool_disk_type    = "Managed"

  user_pool_enable       = false
  user_pool_name         = "workload"
  user_pool_vm_size      = "Standard_D4s_v3"
  user_pool_min_node_count = 1
  user_pool_max_node_count = 2
  user_pool_disk_size    = 40
  user_pool_disk_type    = "Managed"

  tags = {
    env   = "dev"
    owner = "techrip"
  }
}
