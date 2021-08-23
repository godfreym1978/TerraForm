provider "aws" {
    region = "us-east-2"
}

resource "aws_instance" "example"{
    ami = "ami-028f0daffc74d96ee"
    instance_type = "t2.micro"
}