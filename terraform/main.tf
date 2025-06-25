# Artifact Registry (opcional)
resource "google_artifact_registry_repository" "repo" {
  provider      = google
  repository_id = "strapi-repo"
  location      = var.region
  format        = "DOCKER"
}

# Service Account
resource "google_service_account" "sa" {
  account_id   = "strapi-sa"
  display_name = "Service Account for Strapi Cloud Run"
}

# Cloud Run
resource "google_cloud_run_service" "strapi" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.sa.email
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

# Permitir invocação pública
resource "google_cloud_run_service_iam_member" "invoker" {
  service  = google_cloud_run_service.strapi.name
  location = google_cloud_run_service.strapi.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
