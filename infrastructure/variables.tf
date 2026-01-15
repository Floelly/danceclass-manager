# Project & Region
variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "dance-class-manager-eu"
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "europe-west3"
}

variable "gcp_services" {
  type = list(string)
  default = [
    "compute.googleapis.com",
    "vpcaccess.googleapis.com",
    "servicenetworking.googleapis.com",
    "secretmanager.googleapis.com",
  ]
}

# Netzwerk
variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "dance-class-manager-vpc"
}

variable "subnet_cidr" {
  description = "Subnet CIDR Range"
  type        = string
  default     = "10.8.0.0/28"
}

variable "vpc_access_connector_name" {
  description = "Name of VPC access connector"
  type        = string
  default     = "vpc-access-connector"
}

# Database
variable "database_name" {
  description = "Cloud SQL Database Name"
  type        = string
  default     = "dance_class_manager"
}

variable "database_user" {
  description = "Cloud SQL Database User"
  type        = string
  default     = "dance_class_manager_api"
  sensitive   = true
}

variable "vpc_connector_subnet_mask" {
  description = "Subnet mask for SQL user host restriction"
  type        = string
  default     = "10.8.0.%"
}

variable "database_version" {
  description = "MySQL Version"
  type        = string
  default     = "8_0"
}

variable "database_tier" {
  description = "Cloud SQL Tier (kostenoptimiert)"
  type        = string
  default     = "db-f1-micro" # "db-g1-small" for more speed but more costs
}





# variable "availability_zones" {
#   description = "Availability Zones für Multi-Zone Setup"
#   type        = list(string)
#   default     = ["europe-west3-a", "europe-west3-b", "europe-west3-c"]
# }

# # Kostenoptimierung: Minimale Ressourcen für MVP
# variable "database_storage_gb" {
#   description = "Cloud SQL Storage in GB"
#   type        = number
#   default     = 10
# }

# # Cloud Run
# variable "cloud_run_memory" {
#   description = "Cloud Run Memory (kostenoptimiert)"
#   type        = string
#   default     = "512Mi"  # 512MB = günstig
# }

# variable "cloud_run_cpu" {
#   description = "Cloud Run CPU"
#   type        = string
#   default     = "0.5"
# }

# variable "cloud_run_min_instances" {
#   description = "Minimum Cloud Run Instances (Keep-Warm)"
#   type        = number
#   default     = 0  # Kostenoptimiert: Nur bei Bedarf
# }

# variable "cloud_run_max_instances" {
#   description = "Maximum Cloud Run Instances (Auto-Scaling)"
#   type        = number
#   default     = 5
# }

# variable "backend_source_dir" {
#   description = "Pfad zum Backend-Code relativ zu 'main.tf'"
#   default     = "../backend"
# }

# # Storage
# variable "storage_location" {
#   description = "Cloud Storage Location"
#   type        = string
#   default     = "EU"
# }

# # Monitoring & Logging
# variable "enable_monitoring" {
#   description = "Enable Cloud Monitoring"
#   type        = bool
#   default     = true
# }

# variable "log_retention_days" {
#   description = "Cloud Logging Retention (Tage)"
#   type        = number
#   default     = 30
# }