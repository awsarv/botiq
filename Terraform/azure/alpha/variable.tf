variable "location" {
  type        = string
  default     = "East US"
  description = "aks region"
}

variable "resource_group_name" {
    type = string
    default = "demo-rg"
}

variable "aks_cluster_name" {
    type = string
    default = "demo-aks"
}

variable "node_count" {
    type = number
    default = 1
}

variable "dns_prefix" {
    type = string
}