# Cloud Run Service: Strapi CMS
resource "google_cloud_run_service" "strapi" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      # Usa a Service Account já criada manualmente
      service_account_name = "strapi-sa@${var.project_id}.iam.gserviceaccount.com"

      containers {
        image = var.image

        # Porta exposta pelo container
        ports {
          container_port = 1337
        }

        # Garante que o Strapi escute em todas as interfaces
        env {
          name  = "HOST"
          value = "0.0.0.0"
        }
      }

      # Aumenta o tempo máximo de inicialização (em segundos)
      timeout_seconds = 300
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Permitir invocação pública pelo allUsers
resource "google_cloud_run_service_iam_member" "invoker" {
  service  = google_cloud_run_service.strapi.name
  location = google_cloud_run_service.strapi.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
