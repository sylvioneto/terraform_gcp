data "google_project" "project" {}

locals {
  resource_labels = {
    terraform = "true"
    app       = "cloud-foundation"
    purpose   = "demo"
    env       = "sandbox"
    repo      = "terraform_gcp"
  }
}

variable "resource_labels" {
  description = "Dictionary of labels"
  default = {}
}

variable "project_id" {
  description = "GCP Project ID"
  default     = null
}

variable "region" {
  type        = string
  description = "GCP region"
  default     = null 
}

variable "network_name" {
  type = string
  description = "VPC name"
}

variable "subnet_cidr" {
  type = string
  description = "Default subnet CIDR"
}

variable "service_networking" {
  type = string
  description = "Service Networking range, prefix 16"
}
