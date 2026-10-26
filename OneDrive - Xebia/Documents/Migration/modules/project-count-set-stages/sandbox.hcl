# ---------------------------------------------------------------------------
# Module: project-count-set-stages
# Self-contained: sandbox + tabs + layout all in this file.
# ---------------------------------------------------------------------------

resource "network" "main" {
  subnet = "10.0.202.0/24"
}

resource "container" "mongodb" {
  image {
    name = "europe-west1-docker.pkg.dev/curriculum-labs/prod/mongodb-image:v0.8.0"
  }

  environment = {}

  resources {
    cpu    = 1000
    memory = 1024
  }

  network {
    id = resource.network.main.meta.id
  }
}

resource "terminal" "mongosh" {
  target = resource.container.mongodb
  shell  = "/bin/bash"
  cmd    = "/scripts/mongosh.sh"
}

resource "terminal" "bash" {
  target = resource.container.mongodb
  shell  = "/bin/bash"
}

resource "layout" "default" {
  content {
    type = "split-left"
    left {
      type    = "tabs"
      content = [resource.terminal.mongosh, resource.terminal.bash]
    }
    right {
      type = "instructions"
    }
    left_size = 67
  }
}
