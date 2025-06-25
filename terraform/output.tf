output "url" {
  value = google_cloud_run_service.strapi.status[0].url
}
