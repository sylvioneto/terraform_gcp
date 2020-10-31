locals {
  _labels = {
    project   = var.project_id
    env       = var.env
    tf-module = "core"
  }
  labels = merge(local._labels, var.labels)
}

variable "project_id" {
  description = "project_id"
}

variable "env" {
  description = "Describe the environment type: sandbox, dev, qa, prod"
}

variable "region" {
  description = "Region used by default in all regional resources. https://cloud.google.com/compute/docs/regions-zones"
  default     = "us-central1"
}

variable "bq_location" {
  description = "BigQuery datasets default location"
  default     = "US"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "10.0.0.0/8"
}

variable "ssh_cidr" {
  description = "Allow this CIDR to ssh to the instances with the tag allow-ssh"
}

variable "labels" {
  description = "Additional labels"
  default     = {}
}
