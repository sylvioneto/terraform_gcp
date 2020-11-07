locals {
  _labels = {
    tf-module = "gke"
  }
  labels = merge(local._labels, var.labels)
}

variable "region" {
  description = "Region used by default in all regional resources. https://cloud.google.com/compute/docs/regions-zones"
  default     = "us-central1"
}

variable "name" {
  type        = string
  description = "Cluster name"
}

variable "vpc" {
  type        = string
  description = "VPC name or self-link"
}

variable "ip_cidr_range" {
  type        = string
  description = "Subnet ip_cidr_rang"
  default     = "10.1.0.0/22"
}

variable "ip_allocation_ranges" {
  type        = map
  description = "CIDR map for cluster, pods, and services."
  default = {
    pods     = "10.1.4.0/22",
    services = "10.1.8.0/24",
    master   = "10.1.9.0/28",
  }
}

variable "labels" {
  description = "Additional labels"
  default     = {}
}
