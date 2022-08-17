variable "project_id" {
  description = "GCP Project ID"
  default     = null
}

variable "region" {
  description = "GCP Project ID"
  default     = "southamerica-east1"
}

locals {
  labels = {
    terraform   = "true"
    cost-center = "training"
    env         = "dev"
    owner       = "data-engineering"
  }
}
