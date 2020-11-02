# variables.tf

variable "access_key" {
}
variable "secret_key" {
}
variable "region" {
}

variable "availabilityZone" {
	type = "list"
	default = ["us-east-1a", "us-east-1b"]
}

variable "instanceTenancy" {
    default = "default"
}
variable "dnsSupport" {
    default = true
}
variable "dnsHostNames" {
    default = true
}
variable "vpcName" {
    default = "Test_VPC"
}
variable "vpcCIDRblock" {
    default = "10.0.0.0/16"
}
variable "subnetPublic1" {
    default = "Public1_SNet"
}
variable "subnetPublic2" {
    default = "Public2_SNet"
}
variable "subnetPrivate1" {
    default = "Private1_SNet"
}
variable "subnetPrivate2" {
    default = "Private2_SNet"
}
variable "subnetCIDRblockPub" {
    type = "list"
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "subnetCIDRblockPriv" {
    type = "list"
    default = ["10.0.3.0/24", "10.0.4.0/24"]
}
variable "destinationCIDRblock" {
    default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "egressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "mapPublicIP" {
    default = true
}
variable "publicSG" {
    default = "Public_SG"
}
variable "privateSG" {
    default = "Private_SG"
}
variable "vpcPubACL" {
    default = "Pub_ACL"
}
variable "vpcPrivACL" {
    default = "Priv_ACL"
}
variable "vpcIGwy" {
    default = "Test_IGWY"
}
variable "vpcPubRT" {
    default = "Public_RT"
}
variable "vpcPrivRT" {
    default = "Private_RT"
}

variable "alb_listener_port" {
    default = "80"
}
variable "alb_listener_protocol" {
    default = "tcp"
}


# end of variables.tf
