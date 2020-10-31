# Bucket to store Cloud Build logs
# Ref: https://cloud.google.com/cloud-build/docs/securing-builds/store-manage-build-logs#store-default-bucket
resource "google_storage_bucket" "cloudbuild_logs" {
  name          = "${var.project_id}-cloudbuild-logs"
  location      = var.region
  storage_class = "STANDARD"
  force_destroy = true

  labels = local.labels

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

# Bucket to store Cloud Build artifacts
# Ref: https://cloud.google.com/cloud-build/docs/building/store-build-artifacts
resource "google_storage_bucket" "cloudbuild_artifacts" {
  name          = "${var.project_id}-cloudbuild-artifacts"
  location      = var.region
  storage_class = "STANDARD"
  force_destroy = true

  labels = local.labels

  versioning {
    enabled = false
  }
}

# Bucket to store VM startup logs
resource "google_storage_bucket" "vm_logs" {
  name          = "${var.project_id}-vm-logs"
  location      = var.region
  storage_class = "STANDARD"
  force_destroy = true

  labels = merge(local.labels, { purpose = "vm-logs" })

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

# Bucket to store Helm Charts
# For more information: https://github.com/hayorov/helm-gcs
resource "google_storage_bucket" "helm_charts" {
  name          = "${var.project_id}-helm-charts"
  location      = var.region
  storage_class = "STANDARD"
  force_destroy = true

  labels = merge(local.labels, { purpose = "helm-charts" })

  versioning {
    enabled = false
  }
}

# Bucket to store Terraform states
# Ref: https://www.terraform.io/docs/backends/types/gcs.html
resource "google_storage_bucket" "terraform_state" {
  name          = "${var.project_id}-terraform-state"
  location      = var.region
  storage_class = "STANDARD"
  force_destroy = true

  labels = merge(local.labels, { purpose = "tf-state" })

  versioning {
    enabled = false
  }
}
