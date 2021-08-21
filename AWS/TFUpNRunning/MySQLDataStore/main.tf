
provider "aws" {
  region = "us-east-2"
}

resource "aws_db_instance" "ExampleMySQLDB" {
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  name = "ExampleMySQLDB"
  username = "admin"
  password = "${var.db_password}"
}