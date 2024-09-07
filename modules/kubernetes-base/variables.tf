variable "pool_ids" {
  type        = list(string)
  description = "LKE Cluster Pool IDs"
}

variable "authorized_keys" {
  type        = list(string)
  description = "Authorized SSH Public Keys"
  default     = []
}

variable "linode_token" {
  type        = string
  description = "Linode API token"
}

variable "load_balancer_ip" {
  type        = string
  description = "IP Address of Load Balancer"
}

variable "load_balancer_ipv6" {
  type        = string
  description = "IPv6 Address of Load Balancer"
}

variable "http_port" {
  type        = string
  description = "HTTP NodePort of Ingress Controller"
}

variable "https_port" {
  type        = string
  description = "HTTPS NodePort of Ingress Controller"
}

variable "cluster_id" {
  type        = string
  description = "LKE cluster ID"
}