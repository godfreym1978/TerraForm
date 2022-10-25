

provider "google" {
  #project     = "arctic-robot-361223"
  project     = var.project
}

data "terraform_remote_state" "db" {
  backend = "gcs"
  config = {
    # Replace this with your bucket name!
    bucket  = "gpmgcp22q3-tf-state"
    #key    = "terraform/state/default.tfstate"
    #region = "us-east-2"
  }
}

resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
}