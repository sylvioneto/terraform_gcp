locals {
  project_id = "<YOUR-PROJECT-ID>"
  region   = "us-central1"
  vpc_name = "gke-vpc"

  cluster_name = "gke-dev"
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
    feature     = "feature2"
  }
}
