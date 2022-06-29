data "google_project" "project" {}

locals {
  composer_env_name = "composer-af2"
  resource_labels = {
    terraform = "true"
    app       = "data-analytics"
    purpose   = "demo"
    env       = "sandbox"
    repo      = "terraform_gcp"
  }

  service_account = {
    email  = google_service_account.service_account.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
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
