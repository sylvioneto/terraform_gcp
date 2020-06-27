# Terraform for Google Cloud Platform

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
- [core](./core): it creates resources that are used project-wise. VPC, subnets, firewall rules, and buckets.
- [mig](./mig): it creates a regional Managed Instance Group in a given subnet. It includes Logging and Monitoring agents, and Autoscaling.

## Examples

### Description
The block below creates a project with a VPC, subnets, and 2 instance groups (front-end and backend).
Also, it attaches two tags to the VMs:
- allow-ssh: it allows gcloud ssh from external source to the instance.
- allow-internal-all: it allows incoming traffic from other instances within the VPC.
As a result, you can ssh both of them using gcloud, and the front-end can access the back-end instances. You can use `ping` to test this.

```hcl-terraform
locals {
  project_id = "my-test-project"
  region     = "us-central1"
  env        = "sandbox"
}

provider "google" {
  project     = local.project_id
  region      = local.region
  version     = "3.22.0"
}

module "core" {
  source     = "../../modules/core"
  project_id = local.project_id
  region     = local.region
  env        = local.env
  subnets = [
    {
      name = "subnet-a"
      region = local.region
      ip_cidr_range = "10.0.4.0/22"
    },
    {
      name = "subnet-b"
      region = local.region
      ip_cidr_range = "10.0.8.0/22"
    }
  ]
  ssh_cidr = "174.99.99.99/32"
}

module "front_end" {
  source = "../../modules/mig"

  name        = "front-end-servers"
  description = "Order management website"
  owner       = "ordermngt"

  network = module.core.vpc.id
  region  = "us-central1"
  subnet  = "subnet-a"

  network_tags = [
    "front-end",
    "allow-ssh",
  ]

  metadata = {
    log_bucket = module.core.vm_log_bucket
  }
}

module "back_end" {
  source = "../../modules/mig"

  name        = "back-end-servers"
  description = "Order management APIs"
  owner       = "ordermngt"

  network = module.core.vpc.id
  region  = "us-west1"
  subnet  = "subnet-b"

  network_tags = [
    "allow-internal-all",
    "allow-ssh",
  ]

  metadata = {
    log_bucket = module.core.vm_log_bucket
  }
}
```
