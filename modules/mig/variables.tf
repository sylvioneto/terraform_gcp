locals {
  service_account = var.service_account == null ? "${data.google_project.project.number}-compute@developer.gserviceaccount.com" : var.service_account
}

variable "name" {
  description = "Instance group name"
}

variable "description" {
  description = "Instance group description description"
  default     = "Compute Engine template created with Terraform"
}

variable "network" {
  description = "Network name"
}

variable "region" {
  description = "Region where the subnet is located"
}

variable "subnet" {
  description = "Subnet name"
}

variable "machine_type" {
  description = "Machine type. For always free tier please check https://cloud.google.com/free/docs/gcp-free-tier#always-free-usage-limits"
  default     = "f1-micro"
}

variable "startup_script" {
  description = "Startup script. By default it installs Cloud Logging and Cloud Monitoring agents"
  default     = <<EOF
  #! /bin/bash
  curl -sSO https://dl.google.com/cloudagents/install-monitoring-agent.sh
  sudo bash install-monitoring-agent.sh

  curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
  sudo bash install-logging-agent.sh
  EOF
}

variable "image" {
  description = "OS Image"
  default     = "debian-cloud/debian-9"
}

variable "preemptible" {
  description = "Preemptible VM"
  default     = true
}

variable "owner" {
  description = "Who owns the vms created by this template"
}

variable "metadata" {
  description = "Key value metadata map"
  type        = map(string)
  default     = {}
}

variable "network_tags" {
  description = "List of network tags"
  default     = []
}

variable "scopes" {
  description = "Compute Engine scopes. Full list available in https://cloud.google.com/sdk/gcloud/reference/alpha/compute/instances/set-scopes#--scopes"
  type        = list(string)
  default     = ["logging-write", "monitoring-write", "storage-ro", "userinfo-email", "service-management", "pubsub"]
}

variable "autoscaler_config" {
  description = "Autoscaler configuration"
  type        = map
  default = {
    max_replicas    = 5
    min_replicas    = 1
    cpu_target      = 0.75
    cooldown_period = 90
  }
}

variable "service_account" {
  description = "VMs service account"
  default     = null
}

