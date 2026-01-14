output "project_details" {
  value = {
    project_id     = data.google_project.project.id
    project_number = data.google_project.project.number
    name           = data.google_project.project.name
  }
}