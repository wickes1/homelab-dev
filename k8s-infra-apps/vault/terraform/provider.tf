provider "kubernetes" {
  host               = var.k8s_host
  insecure           = var.insecure
  client_certificate = file(var.client_certificate)
  client_key         = file(var.client_key)
}

provider "helm" {
  kubernetes {
    host               = var.k8s_host
    insecure           = var.insecure
    client_certificate = file(var.client_certificate)
    client_key         = file(var.client_key)
  }
}
