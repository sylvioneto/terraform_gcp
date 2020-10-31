# Core module

## Description
It creates core resources that are useful in any GCP project:
- BigQuery GKE Metering dataset
- Cloud Build buckets
- VPC, NAT and Router
- Firewall rules

### Usage

```hcl-terraform
locals {
  project_id = "myname-sandbox"
  region     = "us-central1"
  env        = "sandbox"
}

provider "google" {
  project     = local.project_id
  region      = local.region
  version     = "3.41.0"
}

module "core" {
  source     = "git::git@github.com:sylvioneto/terraform_gcp.git//modules/core"
  project_id = local.project_id
  region     = local.region
  env        = local.env
  ssh_cidr   = "XXX.XXX.XXX.XXX/32"
  labels = {
      cost-center="training"
  }
}
```