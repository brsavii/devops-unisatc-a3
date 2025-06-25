# Cloud Run
resource "google_cloud_run_service" "strapi" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      # usa a SA que você já criou manualmente
      service_account_name = "strapi-sa@${var.project_id}.iam.gserviceaccount.com"

      containers {
        image = var.image
        ports {
          container_port = 1337
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Permitir invocação pública (allUsers)
resource "google_cloud_run_service_iam_member" "invoker" {
  service  = google_cloud_run_service.strapi.name
  location = google_cloud_run_service.strapi.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
