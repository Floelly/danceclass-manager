# service account for cloud run backend service
resource "google_service_account" "cloud_run_sa" {
  account_id = "cloud-run-backend-sa"
  display_name = "Cloud run backend service account"
  depends_on = [ google_project_service.enabled_apis ]
}

# IAM Bindings
# rights for going through vpc access
resource "google_project_iam_member" "cloud_run_vpc_accessor" {
  member = "serviceAccount:${google_service_account.cloud_run_sa.email}"
  project = var.project_id
  role = "roles/vpcaccess.user"
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
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}
resource "google_secret_manager_secret_iam_member" "cloud_run_db_password_access" {
    secret_id = google_secret_manager_secret.db_password.secret_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}