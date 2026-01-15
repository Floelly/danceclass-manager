# Cloud SQL instance
resource "google_sql_database_instance" "database" {
  database_version = "MYSQL_${var.database_version}"
  settings {
    tier                        = var.database_tier
    availability_type           = "REGIONAL"
    deletion_protection_enabled = false # 'true' for production like safety
    retain_backups_on_delete    = false # 'true' for production like safety
    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }
    ip_configuration {
      ipv4_enabled = false
      # use an IP of the tunnel defined in google_service_networking_connection.cloudsql_private_vpc_connection
      private_network = google_compute_network.vpc_network.id
      ssl_mode        = "ENCRYPTED_ONLY"
    }
  }
  deletion_protection = false # only for terraform

  depends_on = [google_service_networking_connection.cloudsql_private_vpc_connection]
}

# Database
resource "google_sql_database" "database_schema" {
  name     = var.database_name
  instance = google_sql_database_instance.database.name
}

# password for database user
resource "random_password" "spring_db_user_password" {
  length  = 24
  special = true
}

# database user for backend api
resource "google_sql_user" "backend-db-user" {
  name     = var.database_user
  instance = google_sql_database_instance.database.name
  password = random_password.spring_db_user_password.result
  host     = var.vpc_connector_subnet_mask
}