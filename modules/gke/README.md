# GKE module

## Description
This modules create a regional Google Kubernetes cluster.
Please explore the variables.tf file to see the values you can set.

### Usage

Example of a basic cluster, with default IP ranges from module, and nodes with ssh firewall tag.

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
  source = "git::git@github.com:sylvioneto/terraform_gcp.git//modules/core?ref=v1.1"
  region = local.region
  labels = local.labels
}

module "gke_cluster" {
  source                   = "git::git@github.com:sylvioneto/terraform_gcp.git//modules/gke?ref=v1.1"
  name                     = "test-1"
  region                   = local.region
  vpc                      = module.core.vpc.self_link
  remove_default_node_pool = false
  resource_labels          = local.labels
  tags                     = ["allow-ext-ssh"]
}
```
