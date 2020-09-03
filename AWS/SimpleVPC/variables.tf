# variables.tf
variable "access_key" {
     default = "AKIAJSRICHXBTQATRYBA"
}
variable "secret_key" {
     default = "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"
}
variable "region" {
     default = "us-east-1"
}
variable "availabilityZone" {
     default = "us-east-1a"
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
    default = "10.1.0.0/16"
}
variable "subnetName" {
    default = "Test_SNet"
}
variable "subnetCIDRblock" {
    default = "10.1.1.0/24"
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
variable "vpcACL" {
    default = "Test_ACL"
}
variable "vpcIGwy" {
    default = "Test_IGWY"
}
variable "vpcRT" {
    default = "Test_RT"
}

# end of variables.tf
