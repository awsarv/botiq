variable "namespace" {
  type    = string
  default = "argocd"
}

variable "domain_name" {
  type    = string
  default = ""
}

variable "replicas" {
  type    = number
  default = 2
}

variable "tls_enabled" {
  type    = bool
  default = true
}

variable "helm_chart_version" {
  type    = string
  default = "5.51.6" # latest at time of writing
}
