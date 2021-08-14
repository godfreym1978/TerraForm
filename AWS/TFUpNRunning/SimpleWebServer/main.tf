provider "aws" {
    region = "us-east-2"
}

resource "aws_instance" "Web_Srv_EC2"{
    ami = "ami-028f0daffc74d96ee"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.Web_Srv_SG.id}"]
    #to utilize the varaiables make sure that variable.tf file is created
    user_data = <<-EOF
        #!/bin/bash
        echo "Hello, World" > index.html
        nohup busybox httpd -f -p "${var.server_port}" &
        EOF
    tags = {
        Name = "Web-Server"
    }
}

resource "aws_security_group" "Web_Srv_SG"{
    name = "Web_Srv_SG"

    #to utilize the varaiables make sure that variable.tf file is created       
    ingress{
        from_port = "${var.server_port}"
        to_port = "${var.server_port}"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}