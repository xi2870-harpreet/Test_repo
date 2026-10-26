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
    # MongoDB's custom image with mongosh, /scripts/lib.sh, local_mongod.sh,
    # and the mdb_edu Python package pre-installed.
    # Source: mongodb sandbox-preset cl-mongodb-1024
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

# NOTE: mongod startup, user creation and dataset import are handled by the
# per-lab task setup scripts (which call /scripts/lib.sh + local_mongod.sh
# from inside the image). No module-level exec is needed here.
