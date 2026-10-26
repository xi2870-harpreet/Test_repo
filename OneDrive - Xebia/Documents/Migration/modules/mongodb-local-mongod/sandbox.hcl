# ---------------------------------------------------------------------------
# Module: mongodb-local-mongod
# Packages the reusable MongoDB sandbox:
#   - Container running MongoDB 7.0 (local mongod)
#   - Network for the container
#   - Exec: start mongod, import sample data
# ---------------------------------------------------------------------------

resource "network" "main" {
  subnet = "10.0.201.0/24"
}

resource "container" "mongodb" {
  image {
    name = "mongo:7.0"
  }

  entrypoint = ["/bin/bash"]
  command    = ["-c", "mongod --fork --logpath /var/log/mongod.log --bind_ip_all && sleep infinity"]

  environment = {
    MONGO_INITDB_DATABASE = "admin"
  }

  resources {
    cpu    = 2000
    memory = 2048
  }

  network {
    id = resource.network.main.meta.id
  }
}

resource "exec" "mongod_setup" {
  target  = resource.container.mongodb
  script  = "scripts/exec/mongod_setup/script.sh"
  timeout = "300s"
}
