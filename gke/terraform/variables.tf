locals {
  vpc_name     = "my-vpc"
  cluster_name = "my-cluster"

  resource_labels = {
    terraform   = "true"
    cost-center = "training"
    env         = "dev"
    owner       = "team1"
    feature     = "system1"
  }
}

variable "project_id" {
  description = "GCP Project ID"
}

variable "dns_domain" {
  description = "DNS domain"
}

variable "region" {
  description = "Region"
  default     = "us-central1"
}
