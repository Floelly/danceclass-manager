output "project_details" {
  value = {
    project_id     = data.google_project.project.id
    project_number = data.google_project.project.number
    name           = data.google_project.project.name
  }
}

output "backend_info" {
  value = {
    vpc                       = google_compute_network.vpc_network.name
    vpc_subnet                = google_compute_subnetwork.vpc_subnetwork.name
    vpc_access_connector      = google_vpc_access_connector.connector.name
    vpc_networking_tunnel_id  = google_service_networking_connection.cloudsql_private_vpc_connection.id
    database_instance         = google_sql_database_instance.database.name
    database_schema_name      = google_sql_database.database_schema.name
    cloud_run_service_account = google_service_account.cloud_run_sa.account_id
    artifact_registry_repo    = google_artifact_registry_repository.docker_repo.repository_id
    cloud_run_service         = google_cloud_run_v2_service.backend_service.name
    cloud_run_docker_image    = google_cloud_run_v2_service.backend_service.template[0].containers[0].image
    cloud_run_iam_policy      = google_cloud_run_service_iam_policy.public_backend.policy_data
  }
}

output "frontend_info" {
  value = {
    bucket_id            = google_storage_bucket.frontend.id
    frontend_ip          = google_compute_global_address.frontend_ip.address
    url_map_id           = google_compute_url_map.frontend.id
    self_signed_cert_end = tls_self_signed_cert.frontend.validity_end_time
    proxy_id             = google_compute_target_https_proxy.frontend.id
    forwarding_rule_id   = google_compute_global_forwarding_rule.frontend.id
  }
}


output "frontend_url" {
  value       = "https://${google_compute_global_address.frontend_ip.address}"
  description = "Frontend über HTTPS Load Balancer"
}

output "backend_url" {
  value       = google_cloud_run_v2_service.backend_service.urls
  description = "Spring Boot API Endpoint"
}