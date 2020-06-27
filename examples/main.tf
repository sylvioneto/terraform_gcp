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
  version     = "3.22.0"
}

module "core" {
  source     = "git::git@github.com:sylvioneto/terraform_gcp.git//modules/core"
  project_id = local.project_id
  region     = local.region
  env        = local.env
  subnets = [
    {
      name          = "subnet-a"
      ip_cidr_range = "10.0.4.0/22"
    },
    {
      name          = "subnet-b"
      ip_cidr_range = "10.0.8.0/22"
    }
  ]
  ssh_cidr = "111.11.11.11/32"
}

module "front_end" {
  source     = "git::git@github.com:sylvioneto/terraform_gcp.git//modules/mig"

  name        = "front-end-servers"
  description = "Order management website"
  owner       = "ordermngt"

  network = module.core.vpc.id
  region  = local.region
  subnet  = module.core.subnets[0]

  network_tags = [
    "front-end",
    "allow-ssh",
  ]

  metadata = {
    log_bucket = module.core.vm_log_bucket
  }

  startup_script = file("startup.bash")
}

module "back_end" {
  source     = "git::git@github.com:sylvioneto/terraform_gcp.git//modules/mig"

  name        = "back-end-servers"
  description = "Order management APIs"
  owner       = "ordermngt"

  network = module.core.vpc.id
  region  = local.region
  subnet  = module.core.subnets[1]

  network_tags = [
    "allow-internal-all",
    "allow-ssh",
  ]

  metadata = {
    log_bucket = module.core.vm_log_bucket
  }
}
