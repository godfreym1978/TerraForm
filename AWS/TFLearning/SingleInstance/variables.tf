#variables that are changable.
variable "ami" {
  description = "Amazon Machine Instance to use"
  #default = "ami-028f0daffc74d96ee"
}

variable "instance_type" {
  description = "Instance type/size"
  #default = "t2.micro"
}