variable "vault_address" {
  description = "The address of the Vault server"
}

variable "vault_token" {
  description = "The token used to authenticate to the Vault server"
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token
}

provider "kubernetes" {
  config_path = "~/.kube/config"

}

resource "vault_mount" "apps_engine" {
  path        = "apps/"
  type        = "kv-v2"
  description = "Key-Value v2 engine for storing application secrets"
}

resource "vault_auth_backend" "kubernetes" {
  type  = "kubernetes"
  path  = "kubernetes"
  local = true
}

resource "vault_policy" "apps_read_policy" {
  name   = "apps-read-policy"
  policy = file("${path.module}/apps-read-policy.hcl")
}

data "kubernetes_service" "kubernetes" {
  metadata {
    name      = "kubernetes"
    namespace = "default"
  }
}

output "kubernetes_service_ip" {
  value = data.kubernetes_service.kubernetes.spec.0
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  kubernetes_host = format("https://%s:%d", data.kubernetes_service.kubernetes.spec.0.cluster_ip, data.kubernetes_service.kubernetes.spec.0.port.0.port)
}

resource "vault_kubernetes_auth_backend_role" "apps_secret_store" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "apps-secret-store"
  bound_service_account_names      = ["apps-secret-store"]
  bound_service_account_namespaces = ["apps"]
  token_policies                   = ["apps-read-policy"]
  token_ttl                        = 3600
}
