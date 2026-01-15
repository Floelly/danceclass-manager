# service account for cloud run backend service
resource "google_service_account" "cloud_run_sa" {
  account_id   = "cloud-run-backend-sa"
  display_name = "Cloud run backend service account"
  depends_on   = [google_project_service.enabled_apis]
}

# IAM Bindings
# rights for going through vpc access
resource "google_project_iam_member" "cloud_run_vpc_accessor" {
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
  project = var.project_id
  role    = "roles/vpcaccess.user"
}
# rights for writing cloud logs
resource "google_project_iam_member" "cloud_run_logs_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}
# rights for writing metrics
resource "google_project_iam_member" "cloud_run_metrics_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}
# rights for reading db secrets from secret manager
resource "google_secret_manager_secret_iam_member" "cloud_run_db_user_access" {
  secret_id = google_secret_manager_secret.db_user.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}
resource "google_secret_manager_secret_iam_member" "cloud_run_db_password_access" {
  secret_id = google_secret_manager_secret.db_password.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

# Artifact Registry Repo (für Docker Image)
resource "google_artifact_registry_repository" "docker_repo" {
  repository_id = "${var.project_id}-docker-repo"
  format        = "DOCKER"
  description   = "Repository for Docker Container Images"
}

# cloud run service erstellen
resource "google_cloud_run_v2_service" "backend_service" {
  location = var.region
  name     = "${var.project_id}-backend-service"

  scaling {
    max_instance_count = var.cloud_run_max_instances
    min_instance_count = var.cloud_run_min_instances
  }

  template {
    service_account = google_service_account.cloud_run_sa.email

    vpc_access {
      connector = google_vpc_access_connector.connector.id
    }

    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello" # dummy. später dann folgendes:
      # image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.docker_repo.repository_id}/backend:latest"
      ports {
        container_port = 8080
        name           = "http1"
      }

      env {
        name  = "DB_HOST"
        value = google_sql_database_instance.database.private_ip_address
      }
      env {
        name  = "DB_PORT"
        value = "3306"
      }
      env {
        name  = "DB_NAME"
        value = var.database_name
      }
      env {
        name = "DB_USER"
        value_source {
          secret_key_ref {
            version = "latest"
            secret  = google_secret_manager_secret.db_user.name
          }
        }
      }
      env {
        name = "DB_PASSWORD"
        value_source {
          secret_key_ref {
            version = "latest"
            secret  = google_secret_manager_secret.db_password.name
          }
        }
      }

      resources {
        limits = {
          cpu    = var.cloud_run_cpu
          memory = var.cloud_run_memory
        }
      }
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  deletion_protection = false
  depends_on = [
    google_project_service.enabled_apis,
    google_secret_manager_secret_iam_member.cloud_run_db_password_access,
    google_secret_manager_secret_iam_member.cloud_run_db_user_access
  ]
}

# backand public machen
data "google_iam_policy" "public" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}
resource "google_cloud_run_service_iam_policy" "public_backend" {
  service     = google_cloud_run_v2_service.backend_service.name
  policy_data = data.google_iam_policy.public.policy_data
}