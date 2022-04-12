variable "org_id" {
  description = "Organization ID"
}

variable "billing_account_id" {
  description = "Billing Account ID"
}

variable "region" {
  default = "us-central1"
}

variable "developers_group" {
  description = "This group will have access to the shared subnets"
  default     = "gcp-developers@example.com"
}