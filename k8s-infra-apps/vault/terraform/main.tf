resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }
}

locals {
  ingress_yaml = yamldecode(file("${path.module}/ingress.yaml"))
}

resource "kubernetes_manifest" "vault_ingress" {
  manifest = local.ingress_yaml
}

resource "helm_release" "vault" {
  depends_on = [
    kubernetes_namespace.vault
  ]
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  namespace  = "vault"
  version    = "0.27.0"

  values = [
    "${file("values.yaml")}"
  ]

  # history
  max_history = 3

  # config
  set {
    name  = "server.ha.enabled"
    value = "true"
  }

  set {
    name  = "server.ha.raft.enabled"
    value = "true"
  }

  set {
    name  = "server.ha.replicas"
    value = var.replicas
  }

  # ingress
  set {
    name  = "server.ingress.enabled"
    value = var.ingress_enabled
  }

  set {
    name  = "server.ingress.ingressClassName"
    value = var.ingress_class_name
  }

  set {
    name  = "server.ingress.hosts[0].host"
    value = var.ingress_host
  }

  set {
    name  = "server.ingress.annotations"
    value = yamlencode(var.ingress_annotations)
  }

  # web UI
  set {
    name  = "ui.enabled"
    value = "true"
  }
}
