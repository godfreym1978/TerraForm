#this will be displayed on the screen after the apply command is finished
output "vpc_name" {
  value = google_compute_network.vpc_network.name
}