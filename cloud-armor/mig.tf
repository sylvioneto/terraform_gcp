data "google_project" "project" {}

module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 7.6.0"

  project_id           = var.project_id
  name_prefix          = local.application_name
  region               = var.region
  network              = module.vpc.network_name
  subnetwork           = "webapp-${var.region}"
  service_account      = local.service_account
  labels               = local.resource_labels
  source_image         = "debian-10-buster-v20220317"
  source_image_project = "debian-cloud"

  startup_script = <<EOF
  sudo apt update
  sudo apt install apache2 -y
  EOF

  access_config = [{
    nat_ip       = null
    network_tier = "PREMIUM"
  }]

  tags = [
    "allow-hc",
  ]

  depends_on = [
    module.vpc
  ]
}

module "mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "~> 7.6.0"

  project_id        = var.project_id
  region            = var.region
  target_size       = 1
  hostname          = local.application_name
  instance_template = module.instance_template.self_link

  named_ports = [
    { 
      name = "http"
      port = 80 
    }
  ]

  health_check = {
    type                = "http"
    initial_delay_sec   = 30
    check_interval_sec  = 30
    healthy_threshold   = 1
    timeout_sec         = 10
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 80
    request             = ""
    request_path        = "/"
    host                = ""
  }
}
