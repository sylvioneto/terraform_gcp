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

# Cloud Build permissions
resource "google_project_iam_member" "gke_admin" {
  role   = "roles/container.admin"
  member = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "network_user" {
  role   = "roles/compute.networkUser"
  member = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}
