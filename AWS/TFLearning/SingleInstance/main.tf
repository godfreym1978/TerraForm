provider "aws" {
    region = "us-east-2"
}

locals  {
    instanceName = "test-instance"
}

resource "aws_instance" "example-ec2"{
    ami = "ami-028f0daffc74d96ee"
    instance_type = "t2.micro"

    tags = {
        name = local.instanceName
    }

}