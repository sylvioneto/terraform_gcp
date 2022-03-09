locals {
  region          = "us-central1"
  network_project = "syl-network"
}

variable "org_id" {
  description = "Organization ID"
}

variable "billing_account_id" {
  description = "Billing Account ID"
}
