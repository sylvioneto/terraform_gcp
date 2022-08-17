variable "project_id" {
  description = "GCP Project ID"
  default     = null
}

variable "region" {
  description = "GCP region"
  default     = "southamerica-east1"
}

locals {
  vpc_name = "gke-sandbox"

  cluster_name = "gke-std-sandbox"
  cluster_ip_ranges = {
    pods     = "10.0.0.0/22"
    services = "10.0.4.0/24"
    nodes    = "10.0.6.0/24"
    master   = "10.0.7.0/28"
  }

  resource_labels = {
    terraform = "true"
    app       = "gke-standard"
    purpose   = "demo"
    env       = "sandbox"
    repo      = "terraform_gcp"
  }
}
