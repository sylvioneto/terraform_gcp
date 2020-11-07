locals {
  _labels = {
    tf-module   = "gke",
    gke-cluster = var.name
  }
  resource_labels = merge(local._labels, var.resource_labels)
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

variable "ip_allocation_ranges" {
  type        = map
  description = "CIDR map for master, pods, and services."
  default = {
    pods     = "10.1.0.0/22",
    services = "10.1.4.0/24",
    master   = "10.1.5.0/28",
  }
}

variable "ip_cidr_range" {
  type        = string
  description = "CIDR where the nodes will be placed."
  default     = "10.1.6.0/24"
}

variable "master_authorized_cidr_blocks" {
  type        = list
  description = "List of CIDR authorized to access the GKE cluster control plane. It's highly recommended to use private blocks."
  default = [
    {
      cidr_block   = "0.0.0.0/0"
      display_name = "internet"
    },
  ]
}

variable "machine_type" {
  type        = string
  description = "GCP machine type"
  default     = "g1-small"
}

variable "preemptible" {
  type        = bool
  description = "Preemptible VMs"
  default     = true
}

variable "remove_default_node_pool" {
  type        = bool
  description = "Remove the default node pool"
  default     = true
}

variable "release_channel" {
  type        = string
  description = "GKE updates release channel."
  default     = "STABLE"
}

variable "default_max_pods_per_node" {
  type        = number
  description = "default max pods per node"
  default     = 32
}

variable "iam_roles" {
  type        = list
  description = "List of cluster service account roles"
  default = [
    "roles/storage.objectViewer",
    "roles/logging.logWriter",
    "roles/monitoring.admin",
    "roles/cloudtrace.admin",
    "roles/servicemanagement.reporter"
  ]
}

variable "resource_labels" {
  description = "Resource labels"
  default     = {}
}

variable "tags" {
  description = "Network tags"
  default     = []
}
