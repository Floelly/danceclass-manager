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
}

# vpc access connector
resource "google_vpc_access_connector" "connector" {
  name = var.vpc_access_connector_name
  subnet {
    name = google_compute_subnetwork.vpc_subnetwork.name
  }
  min_instances = 2
  max_instances = 5
}

# blocking an ip range (for VPC peering with Cloud SQL net)
resource "google_compute_global_address" "cloudsql_psa_range" {
  name          = "cloud-sql-peering-block"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16

  network = google_compute_network.vpc_network.id

  depends_on = [
    google_compute_subnetwork.vpc_subnetwork
  ]
}

# VPC peering
resource "google_service_networking_connection" "cloudsql_private_vpc_connection" {
  network = google_compute_network.vpc_network.id
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.cloudsql_psa_range.name
  ]

  deletion_policy         = "ABANDON"
  update_on_creation_fail = true
}