data "google_project" "project" {}

locals {
  resource_labels = {
    terraform = "true"
    app       = "cloud-armor"
    purpose   = "demo"
    env       = "sandbox"
    repo      = "terraform_gcp"
  }

  service_account = {
    email  = google_service_account.service_account.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  application_name = "juice-shop"
}

variable "project_id" {
  description = "GCP Project ID"
  default     = null
}

variable "region" {
  type        = string
  description = "GCP region"
  default     = "southamerica-east1"
}

variable "webapp_cidr" {
  type        = string
  description = "Subnet webapp cidr"
  default     = "10.0.0.0/24"
}
