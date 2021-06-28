# Ref https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/private-cluster

module "gke" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version    = "~> 15.0.0"
  project_id = var.project_id
  region     = var.region
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
  master_authorized_networks = [
    {
      display_name = "canada-office"
      cidr_block   = "34.83.12.168/32"
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

  node_pools = [
    {
      name            = "base"
      machine_type    = "e2-medium"
      min_count       = 1
      max_count       = 5
      local_ssd_count = 0
      disk_size_gb    = 100
      disk_type       = "pd-standard"
      auto_repair     = true
      auto_upgrade    = true
      preemptible     = true
    },
  ]

  depends_on = [
    module.vpc
  ]
}
