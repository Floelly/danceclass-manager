terraform {
  required_version = ">= 1.14"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.15"
    }
  }
  # Not added any remote state bucket for simplicity
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "enabled_apis" {
  for_each = toset(var.gcp_services)

  service = each.key

  # disable_on_destroy = false # for convenience
}

# Data Source for output
data "google_project" "project" {}