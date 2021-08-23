
provider "aws" {
  region = "us-east-2"
}


module "simple-server" {
  source = "../SimpleWebServer"
  #this will override the one set in modules.
  server_port = "8081"
}