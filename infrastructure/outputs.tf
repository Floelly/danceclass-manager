output "project_details" {
  value = {
    project_id     = data.google_project.project.id
    project_number = data.google_project.project.number
    name           = data.google_project.project.name
  }
}

output "vpc_details" {
  value = {
    vpc_name = google_compute_network.vpc_network.name
    vpc_id   = google_compute_network.vpc_network.id
  }
}

output "subnet_details" {
  value = {
    name       = google_compute_subnetwork.vpc_subnetwork.name
    id         = google_compute_subnetwork.vpc_subnetwork.id
    cidr_range = google_compute_subnetwork.vpc_subnetwork.ip_cidr_range
    self_link  = google_compute_subnetwork.vpc_subnetwork.self_link
  }
}

output "frontend_url" {
  value = "https://${google_compute_global_address.frontend_ip.address}"
}