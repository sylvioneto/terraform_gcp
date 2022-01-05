# Ref https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/private-cluster

module "gke" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version    = "~> 17.0.0"
  project_id = var.project_id
  region     = local.region
  name       = local.cluster_name

  network             = module.vpc.network_name
  subnetwork          = local.cluster_name
  ip_range_pods       = "pods"
  ip_range_services   = "services"
  http_load_balancing = false
  network_policy      = false

  // Private cluster setup
  enable_private_nodes   = true
  master_ipv4_cidr_block = local.cluster_ip_ranges.master

  # whitelist who can reach cluster's master nodes
  master_authorized_networks = [
    {
      display_name = "office-br"
      cidr_block   = "192.0.2.11/32"
    },
    {
      display_name = "office-ca"
      cidr_block   = "192.0.2.22/32"
    },
    {
      # not recommended - testing only!
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
}