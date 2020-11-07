# GKE module

## Description
This modules create a regional Google Kubernetes cluster.

### Usage

Example of a basic cluster creation.

```hcl-terraform
locals {
  project_id = "myname-sandbox"
  region     = "us-central1"
  labels = {
    terraform   = "true"
    cost-center = "training"
    env        = "sandbox"
  }
}

provider "google" {
  project = local.project_id
  region  = local.region
  version = "3.41.0"
}

module "core" {
  source     = "git::git@github.com:sylvioneto/terraform_gcp.git//modules/core"
  region = local.region
  labels = local.labels
}

module "gke_cluster" {
  source                   = "git::git@github.com:sylvioneto/terraform_gcp.git//modules/gke"
  name                     = "test1"
  region                   = local.region
  vpc                      = module.core.vpc.self_link
  labels                   = local.labels
  remove_default_node_pool = false
}
```
