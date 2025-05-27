resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.helm_chart_version
  namespace  = var.namespace
  create_namespace = true

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      domain_name = var.domain_name
      replicas    = var.replicas
      tls_enabled = var.tls_enabled
    })
  ]
}
