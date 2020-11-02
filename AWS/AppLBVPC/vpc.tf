# vpc.tf 
# Create VPC/Subnet/Security Group/Network ACL
provider "aws" {
  version    = "~> 2.0"
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}
# create the VPC
resource "aws_vpc" "My_VPC" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy
  enable_dns_support   = var.dnsSupport
  enable_dns_hostnames = var.dnsHostNames
  tags = {
    Name = var.vpcName
  }
} # end resource
# create the Public1 Subnet
resource "aws_subnet" "subnetPublic" {
  count = length(var.subnetCIDRblockPub)
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block = element(var.subnetCIDRblockPub,count.index)
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone = element(var.availabilityZone,count.index)
  tags = {
    Name = "PubSubnet-${count.index+1}"
  }
} # end resource
# create the Private1 Subnet
resource "aws_subnet" "subnetPrivate" {
  count = "${length(var.subnetCIDRblockPriv)}"
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block = "${element(var.subnetCIDRblockPriv,count.index)}"
  //map_public_ip_on_launch = var.mapPrivateIP
  availability_zone = "${element(var.availabilityZone,count.index)}"
  tags = {
    Name = "PrivSubnet-${count.index+1}"
  }
} # end resource

# Create the Security Group
resource "aws_security_group" "My_VPC_Security_Group" {
  vpc_id      = aws_vpc.My_VPC.id
  name        = var.publicSG
  description = "My VPC Security Group"

  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = var.publicSG
    Description = "My VPC Security Group"
  }
} # end resource

# create VPC Network access control list
resource "aws_network_acl" "My_Priv_VPC_Security_ACL" {
  count = length(var.subnetCIDRblockPriv)
  vpc_id     = aws_vpc.My_VPC.id
  subnet_ids = [element(aws_subnet.subnetPrivate.*.id,count.index)]
  tags = {
    Name = var.vpcPrivACL
  }
} # end resource

# create VPC Network access control list
resource "aws_network_acl" "My_Pub_VPC_Security_ACL" {
  count = length(var.subnetCIDRblockPub)
  vpc_id     = aws_vpc.My_VPC.id
  subnet_ids = [element(aws_subnet.subnetPublic.*.id,count.index)]
  # allow ingress port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 22
    to_port    = 22
  }

  # allow ingress port 80 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 80
    to_port    = 80
  }

  # allow ingress ephemeral ports 
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }

  # allow egress port 22 
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 22
    to_port    = 22
  }

  # allow egress port 80 
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 80
    to_port    = 80
  }

  # allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
  tags = {
    Name = var.vpcPubACL
  }
} # end resource
# Create the Internet Gateway
resource "aws_internet_gateway" "My_VPC_GW" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
    Name = var.vpcIGwy
  }
} # end resource
# Create the Public Route Table
resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
    Name = var.vpcPubRT
  }
} # end resource
# Create the Private Route Table
resource "aws_route_table" "Private_RT" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
    Name = var.vpcPrivRT
  }
} # end resource

# Create the Internet Access
resource "aws_route" "My_VPC_internet_access" {
  route_table_id         = aws_route_table.Public_RT.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.My_VPC_GW.id
} # end resource
# Associate the Route Table with the Public Subnet
resource "aws_route_table_association" "PubSNet_Association" {
  count = length(var.subnetCIDRblockPub)
  subnet_id = "${element(aws_subnet.subnetPublic.*.id,count.index)}"
  //subnet_id      = [aws_subnet.subnetPublic1.id, aws_subnet.subnetPublic2.id]
  route_table_id = aws_route_table.Public_RT.id
} # end resource

# Associate the Route Table with the Private Subnet
resource "aws_route_table_association" "PrivSNet_Association" {
  count = length(var.subnetCIDRblockPriv)
  subnet_id = "${element(aws_subnet.subnetPrivate.*.id,count.index)}"
  //subnet_id      = [aws_subnet.subnetPublic1.id, aws_subnet.subnetPublic2.id]
  route_table_id = aws_route_table.Private_RT.id
} # end resource


# create the App LB
resource "aws_alb" "alb" {  
  name            = "test-alb"
  security_groups    = [aws_security_group.My_VPC_Security_Group.id]
  internal        = false  
  
  subnets            = aws_subnet.subnetPublic.*.id
} # end resource



resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    //target_group_arn = aws_lb_target_group.front_end.arn
  }
}

# end vpc.tf
