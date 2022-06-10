data "google_project" "project" {}

locals {
  resource_labels = {
    terraform = "true"
    purpose   = "demo"
    repo      = "terraform_gcp"
    app       = "cloud-armor"
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
  default     = "us-east1"
}

variable "webapp_cidr" {
  type        = string
  description = "Subnet webapp cidr"
  default     = "10.0.0.0/24"
}
