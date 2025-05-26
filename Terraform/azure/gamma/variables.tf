#variable "settings" {
#  type = any
#  default = null
#}

#variable "settings_string" {
 # type = string
 # default = null
#}


variable "settings" {
  type = object({
    subscription_id            = string
    aks_name                   = string
    dns_prefix                 = string
    location                   = string
    resource_group_name        = string
    min_kubernetes_version     = string
    enable_auto_scaling        = bool

    core_pool_name             = string
    core_pool_vm_size          = string
    core_pool_min_node_count   = number
    core_pool_max_node_count   = number
    core_pool_disk_size        = number
    core_pool_disk_type        = string

    user_pool_enable           = bool
    user_pool_name             = string
    user_pool_vm_size          = string
    user_pool_min_node_count   = number
    user_pool_max_node_count   = number
    user_pool_disk_size        = number
    user_pool_disk_type        = string

    tags = map(string)
  })
}
