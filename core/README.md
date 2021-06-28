# Core module

## Description
It creates core resources that are useful in any GCP project:
- BigQuery GKE Metering dataset
- Cloud Build buckets
- VPC, NAT and Router
- Firewall rules

Please explore the variables.tf file to see the values you can set.

### Usage

```hcl
locals {
  project_id = "myname-sandbox"
  region     = "us-central1"
  env        = "sandbox"
}

provider "google" {
  project     = data.google_project.project.project_id
  region      = local.region
  version     = "3.41.0"
}

module "core" {
  source     = "git::git@github.com:sylvioneto/terraform_gcp.git//modules/core?ref=v1.1"
  project_id = data.google_project.project.project_id
  region     = local.region
  env        = local.env
  ssh_cidr   = "XXX.XXX.XXX.XXX/32"
  labels = {
      cost-center="training"
  }
}
```
