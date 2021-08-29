#this will be displayed on the screen after the apply command is finished
output "Instance_name" {
  value = aws_instance.example-ec2.id
}