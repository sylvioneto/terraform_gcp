locals {
  composer_env_name = "composer-af2"
  composer_ip_ranges = {
    pods     = "10.0.0.0/22"
    services = "10.0.4.0/24"
    nodes    = "10.0.6.0/24"
    master   = "10.0.7.0/28"
  }

  resource_labels = {
    terraform = "true"
    app       = "cloud-composer"
    purpose   = "demo"
    env       = "sandbox"
    repo      = "terraform_gcp"
  }

  service_account = {
    email  = google_service_account.service_account.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
