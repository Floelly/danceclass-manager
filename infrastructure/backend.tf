# service account for cloud run backend service
resource "google_service_account" "cloud_run_sa" {
  account_id = "clound-run-backend-sa"
  depends_on = [ google_project_service.enabled_apis ]
}

# rights for going through vpc access
resource "google_project_iam_member" "cloud_run_iam_member" {
  member = "serviceAccount:${google_service_account.cloud_run_sa.email}"
  project = var.project_id
  role = "roles/vpcaccess.user"
}

# rights for reading secret from secret manager
resource "google_project_iam_member" "cloud_run_secret_reader" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}