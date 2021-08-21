#configure the created S3 bucket to save the remote storage.
terraform {
  backend "s3" {
    bucket = "gpm-tfstatestorage-s3"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-2"
    encrypt=true
  }
}