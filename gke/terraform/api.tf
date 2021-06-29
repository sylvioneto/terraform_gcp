resource "google_project_service" "compute" {
  project            = local.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "container" {
  project            = local.project_id
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cb" {
  project            = local.project_id
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "dns" {
  project            = local.project_id
  service            = "dns.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iam" {
  project            = local.project_id
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}
