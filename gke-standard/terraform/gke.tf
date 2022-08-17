# Ref # Ref https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version    = "21.1.0"
  project_id = var.project_id
  region     = var.region
  name       = local.cluster_name

  network                   = module.vpc.network_name
  subnetwork                = local.cluster_name
  ip_range_pods             = "pods"
  ip_range_services         = "services"
  http_load_balancing       = false
  network_policy            = false
  default_max_pods_per_node = 32

  // Private cluster setup
  enable_private_nodes   = true
  master_ipv4_cidr_block = local.cluster_ip_ranges.master

  // whitelist who can reach cluster's master nodes
  // NOTE: internet is not recommended! It is used for testing only.

  master_authorized_networks = [
    {
      display_name = "internet"
      cidr_block   = "0.0.0.0/0"
    }
  ]

  cluster_resource_labels  = local.resource_labels
  release_channel          = "STABLE"
  create_service_account   = true
  remove_default_node_pool = true
  enable_shielded_nodes    = true

  node_pools = [
    {
      name               = "base"
      machine_type       = "e2-standard-2"
      min_count          = 1
      max_count          = 5
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = true
      enable_secure_boot = true
    },
  ]

  node_pools_tags = {
    all = [
      local.cluster_name
    ]
  }

  depends_on = [
    module.vpc
  ]
}
