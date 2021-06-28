# MIG module

## Description
It creates a regional Managed Instance Group in a given subnet. It includes Logging and Monitoring agents, and Autoscaling.

### Usage

Example of a backend servers deployment.

```hcl
locals {
  region     = "us-central1"
  labels = {
    terraform   = "true"
    cost-center = "training"
    env        = "sandbox"
  }
}

provider "google" {
  project     = local.project_id
  region      = local.region
  version     = "3.41.0"
}

module "core" {
  source     = "git::git@github.com:sylvioneto/terraform_gcp.git//modules/core?ref=v1.1"
  project_id = local.project_id
  region     = local.region
  labels = local.labels
}

resource "google_compute_subnetwork" "be_servers" {
  name          = "backend-servers"
  ip_cidr_range = "10.1.0.0/16"
  region        = "us-central1"
  network       = module.core.vpc.id
}

module "order_man_be" {
  source     = "git::git@github.com:sylvioneto/terraform_gcp.git//modules/mig?ref=v1.1"

  name        = "order-man-be"
  description = "Order Management backend servers"
  region      = local.region
  network     = module.core.vpc.id
  subnet      = google_compute_subnetwork.be_servers.name

  network_tags = [
    "allow-internal-all",
    "allow-ext-ssh",
  ]

  metadata = {
    log_bucket = module.core.vm_log_bucket.name
  }

  labels = local.labels
}
```
