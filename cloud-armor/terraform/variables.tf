data "google_project" "project" {}

locals {
  resource_labels = {
    terraform = "true"
    purpose   = "demo"
    repo      = "terraform_gcp"
    app       = "cloud-armor"
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
