resource "google_compute_node_template" "soletenant_tmpl" {
  name      = "win-soletenant-template"
  region    = "southamerica-east1"
  node_type = "c2-node-60-240"
}

resource "google_compute_node_group" "soletenant_grp" {
  name        = "win-soletenant-grp"
  zone        = "southamerica-east1-a"
  description = "Sole-tenant nodes to host Windows VMs"

  size          = 1
  node_template = google_compute_node_template.soletenant_tmpl.id
}
