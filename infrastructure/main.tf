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

# Data Source for output
data "google_project" "project" {}