#Create a S3 bucket to store the storage. This bucket will be used to store the remote storage.
provider "aws" {
    region = "us-east-2"
}

resource "aws_s3_bucket" "gpm-tfstatestorage-s3"{
    bucket = "gpm-tfstatestorage-s3"

    versioning {
        enabled = true
    }

    lifecycle {
        prevent_destroy = false
    }
}

