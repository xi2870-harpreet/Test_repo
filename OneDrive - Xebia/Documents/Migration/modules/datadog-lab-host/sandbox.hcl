# ---------------------------------------------------------------------------
# Module: datadog-lab-host
#
# MIGRATION NOTE: The original Datadog tracks use custom GCP VM images
# (e.g. datadog-community/generic-course-1-0-0) with Docker Compose inside.
# These are not Docker images and cannot be used directly as container images.
#
# To complete this module, Datadog must:
# 1. Build a Docker image from their VM image contents
# 2. Push it to a registry accessible from Instruqt
# 3. Replace "datadog-community/lab-host:PLACEHOLDER" below with the real image
#
# The lc-env credential tool and GCP secrets are modelled here as env vars
# that must be injected by the lab at runtime (via lab-level variables).
# ---------------------------------------------------------------------------

resource "network" "main" {
  subnet = "10.0.202.0/24"
}

# Placeholder — replace image name once Datadog publishes a Docker image
resource "container" "lab_host" {
  image {
    name = "datadog-community/lab-host:PLACEHOLDER"
  }

  entrypoint = ["/bin/bash"]
  command    = ["-c", "sleep infinity"]

  environment = {
    LEARNING_CENTER_API_ACCESS_TOKEN = var.learning_center_api_token
    LEARNING_CENTER_ENDPOINT         = var.learning_center_endpoint
    LEARNING_CENTER_ASSETS_URL       = var.learning_center_assets_url
  }

  resources {
    cpu    = 4000
    memory = 8192
  }

  network {
    id = resource.network.main.meta.id
  }
}

resource "exec" "lab_host_setup" {
  target  = resource.container.lab_host
  script  = "scripts/exec/lab_host_setup/script.sh"
  timeout = "600s"
}
