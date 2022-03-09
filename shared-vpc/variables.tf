locals {
  region             = "us-central1"
  network_project_id = "syl-network-002"
}

variable "org_id" {
  description = "Organization ID"
}

variable "billing_account_id" {
  description = "Billing Account ID"
}
