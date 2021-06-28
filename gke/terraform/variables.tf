locals {
  project_id = "<SET-PROJECT-ID>"
  dns_name   = "<SET-DNS-NAME>"

  region   = "us-central1"
  vpc_name = "my-vpc"

  cluster_name = "my-dev-cluster"
  cluster_ip_ranges = {
    pods     = "10.1.0.0/22"
    services = "10.1.4.0/24"
    nodes    = "10.1.6.0/24"
    master   = "10.1.7.0/28"
  }

  resource_labels = {
    terraform   = "true"
    cost-center = "training"
    env         = "dev"
    owner       = "team1"
    feature     = "system1"
  }
}
