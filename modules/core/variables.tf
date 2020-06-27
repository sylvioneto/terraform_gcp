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

variable "subnets" {
  description = "Subnet list."
  default = [
    {
      name          = "oregon"
      ip_cidr_range = "10.0.4.0/22"
      region        = "us-west1"
    },
    {
      name          = "iowa"
      ip_cidr_range = "10.0.8.0/22"
      region        = "us-central1"
    },
    {
      name          = "south-carolina"
      ip_cidr_range = "10.0.12.0/22"
      region        = "us-east1"
    },
    {
      name          = "belgium"
      ip_cidr_range = "10.0.16.0/22"
      region        = "europe-west1"
    },
    {
      name          = "sao-paulo"
      ip_cidr_range = "10.0.20.0/22"
      region        = "southamerica-east1"
    },
  ]
}

variable "ssh_cidr" {
  description = "Allow this CIDR to ssh to the instances with the tag allow-ssh"
}
