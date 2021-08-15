provider "aws" {
    region = "us-east-2"
}

data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "Web_Srv_ASG"{
    
    launch_configuration = "${aws_launch_configuration.Web_Srv_EC2.id}"
    availability_zones = ["${data.aws_availability_zones.all.names[0]}", "${data.aws_availability_zones.all.names[1]}"]

    load_balancers = ["${aws_elb.Web_Srv_ELB.name}"]
    min_size = 2
    max_size = 10

    tag  {
        key = "Name"
        value = "TF_ASG_Example"
        propagate_at_launch = true
    }
}

resource "aws_launch_configuration" "Web_Srv_EC2"{
    image_id = "ami-028f0daffc74d96ee"
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.Web_Srv_SG.id}"]
    #to utilize the varaiables make sure that variable.tf file is created
    user_data = <<-EOF
        #!/bin/bash
        echo "Hello, World" > index.html
        nohup busybox httpd -f -p "${var.server_port}" &
        EOF
    
    #meta parameter
    lifecycle{
       #create a replacement resource before destroying? this is ideal if you want to create the new resource before destroying the old one.
        #if set then all the resources it depends on should also have this attribute.
        create_before_destroy = true
    }
}

resource "aws_security_group" "Web_Srv_SG"{
    name = "Web_Srv_SG"

    #to utilize the varaiables make sure that variable.tf file is created       
    ingress{
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle{
        create_before_destroy = true
    }
}

resource "aws_elb" "Web_Srv_ELB" {
    name = "Web-Srv-ELB"
    availability_zones = ["${data.aws_availability_zones.all.names[0]}", "${data.aws_availability_zones.all.names[1]}"]
    security_groups = ["${aws_security_group.Web_Srv_Elb_SG.id}"]

    listener{
        lb_port = 80
        lb_protocol = "http"
        instance_port = var.server_port
        instance_protocol = "http"
    } 

    health_check{
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 2
        interval = 30
        target = "HTTP:${var.server_port}/"
    }
}

resource "aws_security_group" "Web_Srv_Elb_SG"{
    name = "Web_Srv_Elb_SG"

    #to utilize the varaiables make sure that variable.tf file is created       
    ingress{
        from_port = var.elb_port
        to_port = var.elb_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }


    lifecycle{
        create_before_destroy = true
    }
}
