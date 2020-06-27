# Users can set this bucket in logBucket cloudbuild.yaml for output
resource "google_storage_bucket" "cloudbuild_logs" {
  name          = "${var.project_id}-cloudbuild-logs"
  location      = var.region
  storage_class = "STANDARD"
  force_destroy = true

  labels = {
    project = var.project_id
    purpose = "cloudbuild-logs"
    env     = var.env
  }

  versioning {
    enabled = false
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = "30"
    }
  }
}

# Users can use this bucket to store Cloud Build artifacts
resource "google_storage_bucket" "cloudbuild_artifacts" {
  name          = "${var.project_id}-cloudbuild-artifacts"
  location      = var.region
  storage_class = "STANDARD"
  force_destroy = true

  labels = {
    project = var.project_id
    purpose = "cloudbuild-artifacts"
    env     = var.env
  }

  versioning {
    enabled = false
  }
}

# This bucket stores Ms startup/shutdown script logs.
resource "google_storage_bucket" "vm_logs" {
  name               = "${var.project_id}-vm-logs"
  location           = var.region
  storage_class      = "STANDARD"
  force_destroy      = true

  labels = {
    project = var.project_id
    purpose = "vm-logs"
    env     = var.env
  }

  versioning {
    enabled = false
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = "30"
    }
  }
}

# This bucket is used as a Helm Chart private repository
# For more information: https://github.com/hayorov/helm-gcs
resource "google_storage_bucket" "helm_charts" {
  name               = "${var.project_id}-helm-charts"
  location           = var.region
  storage_class      = "STANDARD"
  force_destroy      = true

  labels = {
    project = var.project_id
    purpose = "store-helm-charts"
    env     = var.env
  }

  versioning {
    enabled = false
  }
}
