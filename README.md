# Terraform modules and examples for Google Cloud Platform

## Description
Terraform modules to use on Google Cloud Platform - GCP  
All modules are set to use free tier by default in order to help to explore GCP without costs.  
However, Google might change free-tier eligibility so please double check https://cloud.google.com/free/docs/gcp-free-tier

## Author
email: sylvio.pedroza@gmail.com  
linkedin: https://www.linkedin.com/in/spedrozaneto/?locale=en_US

## Pre-req
- terraform 0.12.25 or later
- google provider 3.12 or later

## Modules
- [core](./core): it creates resources that are used project-wise. VPC, firewall rules, Nat, router, and buckets.
- [mig](./mig): it creates a regional Managed Instance Group in a given subnet. It includes Logging and Monitoring agents, and Autoscaling.

## Examples

### Description
The block below creates a project with a VPC, subnets, and 2 instance groups (front-end and backend).
Also, it attaches two tags to the VMs:
- allow-ssh: it allows gcloud ssh from external source to the instance.
- allow-internal-all: it allows incoming traffic from other instances within the VPC.
As a result, you can ssh both of them using gcloud, and the front-end instance can access the back-end. You can use `ping` to test this.

```hcl-terraform
terraform {
  backend "gcs" {
    bucket = "myproject-tf-state"
    prefix = "mysystem/sanbox"
  }
}

locals {
  project_id = "myproject"
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
  ssh_cidr   = "111.11.11.11/32"
}
```
