# Bucket to store Cloud Build logs
# Ref: https://cloud.google.com/cloud-build/docs/securing-builds/store-manage-build-logs#store-default-bucket
resource "google_storage_bucket" "cloudbuild_logs" {
  name          = "${var.project_id}-cloudbuild-logs"
  location      = var.region
  storage_class = "STANDARD"
  force_destroy = true

  labels = merge(locals.labels, "purpose=cloud-build")

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

  labels = {
    project = var.project_id
    labels = merge(locals.labels, "purpose=cloud-build")
    env     = var.env
  }

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

  labels = merge(locals.labels, "purpose=vm-logs")

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
  
  labels = merge(locals.labels, "purpose=helm-charts")

  versioning {
    enabled = false
  }
}

# Bucket to store Terraform states
# For more information: https://github.com/hayorov/helm-gcs
resource "google_storage_bucket" "helm_charts" {
  name          = "${var.project_id}-terraform-states"
  location      = var.region
  storage_class = "STANDARD"
  force_destroy = true
  
  labels = merge(locals.labels, "purpose=tf-states")

  versioning {
    enabled = false
  }
}
