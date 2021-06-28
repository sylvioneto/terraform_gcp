locals {
  _labels = {
    project   = data.google_project.project.project_id
    tf-module = "core"
  }
  labels = merge(local._labels, var.labels)
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

variable "ssh_cidrs" {
  description = "Allow a list of CIDR to ssh to the instances with the tag allow-ext-ssh"
  default     = []
}

variable "labels" {
  description = "Additional labels"
  default     = {}
}
