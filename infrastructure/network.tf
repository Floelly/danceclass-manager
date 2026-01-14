# network for app
resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  description             = "Only VPC network for ${data.google_project.project.name} Application"
  auto_create_subnetworks = false
  mtu                     = 1460       # Default, but important for vpc connector
  routing_mode            = "REGIONAL" # regional routes only, since app is deployed in only one region

  depends_on = [
    google_project_service.enabled_apis
  ]
}

# private subnet for vpc access connector
resource "google_compute_subnetwork" "vpc_subnetwork" {
  name          = "${var.vpc_name}-subnet"
  description   = "Subnet for VPC Access Connector (Connection Cloud Run -> Cloud SQL)"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = var.subnet_cidr

  depends_on = [google_compute_network.vpc_network]
}