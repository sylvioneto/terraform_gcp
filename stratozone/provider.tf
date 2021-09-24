terraform {
  backend "gcs" {
    bucket = "<YOUR-TF-STATE-BUCKET>"
    prefix = "stratozone"
  }
}

provider "google" {
  project = "<YOUR-PROJECT-ID>"
  region  = "us-central1"
}
