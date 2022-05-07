terraform {
  backend "gcs" {
    bucket  = "gpm-gcp-tf-state"
    prefix  = "terraform/state"
  }
}
