region             = "us-central1"
network_name       = "sandbox-vpc"
subnet_cidr        = "10.0.0.0/24"
service_networking = "10.200.0.0" #/16

resource_labels = {
  terraform = "true"
  app       = "cloud-foundation"
  purpose   = "demo"
  env       = "sandbox"
  repo      = "terraform_gcp"
}
