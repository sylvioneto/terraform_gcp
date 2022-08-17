# # Ref https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/
# data "google_client_config" "default" {}

# provider "kubernetes" {
#   host                   = "https://${module.gke.endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(module.gke.ca_certificate)
# }

# module "gke" {
#   source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"

#   project_id = var.project_id
#   region     = var.region
#   name       = local.cluster_name

#   # networking
#   network                   = module.vpc.network_name
#   subnetwork                = local.cluster_name
#   ip_range_pods             = "pods"
#   ip_range_services         = "services"
#   master_ipv4_cidr_block     = local.cluster_ip_ranges.master

#   horizontal_pod_autoscaling = true
#   filestore_csi_driver       = false
#   enable_private_endpoint    = true
#   enable_private_nodes       = true
#   enable_autopilot           = true
#   http_load_balancing        = false

#   cluster_resource_labels  = local.resource_labels
#   release_channel          = "STABLE"

#   depends_on = [
#     module.vpc
#   ]
# }

resource "google_container_cluster" "primary" {
  name             = local.cluster_name
  location         = var.region
  resource_labels  = local.resource_labels
  enable_autopilot = true

  release_channel {
    channel = "STABLE"
  }

  # networking
  network    = module.vpc.network_name
  subnetwork = local.cluster_name
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  // whitelist who can reach cluster's master nodes
  // NOTE: internet is not recommended! It is used for testing only.
  master_authorized_networks_config {
    cidr_blocks {
      display_name = "internet"
      cidr_block   = "0.0.0.0/0"
    }
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = local.cluster_ip_ranges.master
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  depends_on = [
    module.vpc
  ]
}
