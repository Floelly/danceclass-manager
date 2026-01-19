# Storage Bucket
resource "google_storage_bucket" "frontend" {
  name          = "${var.project_id}-frontend"
  location      = var.region
  force_destroy = true

  versioning {
    enabled = true
  }
  
  website {
    main_page_suffix = "index.html"
  }
  
  uniform_bucket_level_access = true
  depends_on                  = [google_project_service.enabled_apis]
}

# Public Access
resource "google_storage_bucket_iam_member" "public_read" {
  bucket = google_storage_bucket.frontend.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

# Set Global IP 
resource "google_compute_global_address" "frontend_ip" {
  name = "frontend-ip"
}

# Backend Bucket
resource "google_compute_backend_bucket" "frontend" {
  name        = "frontend-backend-bucket"
  bucket_name = google_storage_bucket.frontend.name
  enable_cdn  = true
}