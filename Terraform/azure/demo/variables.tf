variable "resource_group_name" {
  description = "The name of the Resource Group"
  type        = string
  default     = "aks-demo-rg"
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
  default     = "East US"
}

variable "aks_name" {
  description = "Name of the AKS Cluster"
  type        = string
  default     = "aks-demo"
}

variable "aks_dns_prefix" {
  description = "DNS prefix for the AKS Cluster"
  type        = string
  default     = "aksdemodns"
}

variable "agentpool_node_count" {
  description = "Number of nodes in agentpool"
  type        = number
  default     = 1
}

variable "agentpool_vm_size" {
  description = "VM size for agentpool"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "userpool_node_count" {
  description = "Number of nodes in userpool"
  type        = number
  default     = 1
}

variable "userpool_vm_size" {
  description = "VM size for userpool"
  type        = string
  default     = "Standard_DS2_v2"
}
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}
