variable "server_port" {
    description = "Web Server port for HTTP requests"
    default = "8080"
}


variable "elb_port" {
    description = "ELB port for HTTP requests"
    default = "80"
}