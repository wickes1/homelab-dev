variable "k8s_host" {
  description = "Kubernetes API server endpoint"
  type        = string
}

variable "insecure" {
  description = "Whether server should be accessed without verifying the TLS certificate"
  type        = bool
}

variable "client_certificate" {
  description = "Path to the client certificate file"
  type        = string
}

variable "client_key" {
  description = "Path to the client key file"
  type        = string
}

variable "ingress_enabled" {
  description = "Enable ingress"
  type        = bool
  default     = false
}

variable "ingress_class_name" {
  description = "Ingress class name"
  type        = string
  default     = ""
}

variable "ingress_host" {
  description = "Ingress host"
  type        = string
  default     = ""
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 3
}

variable "ingress_annotations" {
  description = "Ingress annotations"
  type        = map(string)
  default = {
    " nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
  }
}
