terraform {
  backend "gcs" {
    bucket  = "gpmgcp22q3-tf-state"
    prefix  = "terraform/state"
  }
}
