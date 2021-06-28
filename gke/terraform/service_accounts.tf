# external-dns service account
resource "google_service_account" "external_dns" {
  account_id   = "external-dns"
  display_name = "External DNS"
}

resource "google_project_iam_member" "external_dns_role" {
  role   = "roles/dns.admin"
  member = "serviceAccount:${google_service_account.external_dns.email}"
}

resource "google_service_account_iam_member" "external_dns_wi" {
  service_account_id = google_service_account.external_dns.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${data.google_project.project.project_id}.svc.id.goog[external-dns/external-dns]"
  depends_on = [
    module.gke
  ]
}

# cert-manager service account
resource "google_service_account" "cert_manager" {
  account_id   = "cert-manager"
  display_name = "cert-manager"
}

resource "google_project_iam_member" "cert_manager_role" {
  role   = "roles/dns.admin"
  member = "serviceAccount:${google_service_account.cert_manager.email}"
}

resource "google_service_account_iam_member" "cert_manager_wi" {
  service_account_id = google_service_account.cert_manager.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${data.google_project.project.project_id}.svc.id.goog[cert-manager/cert-manager]"
  depends_on = [
    module.gke
  ]
}
  
# prometheus service account
resource "google_service_account" "prometheus" {
  account_id   = "prometheus"
  display_name = "prometheus"
}

resource "google_project_iam_member" "prometheus_role" {
  role   = "roles/bigquery.dataViewer"
  member = "serviceAccount:${google_service_account.cert_manager.email}"
}

resource "google_service_account_iam_member" "prometheus_wi" {
  service_account_id = google_service_account.cert_manager.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${data.google_project.project.project_id}.svc.id.goog[prometheus/prometheus]"
  depends_on = [
    module.gke
  ]
}

# Cloud Build permission to deploy to GKE
resource "google_project_iam_member" "cloudbuild_role" {
  role   = "roles/container.admin"
  member = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}
