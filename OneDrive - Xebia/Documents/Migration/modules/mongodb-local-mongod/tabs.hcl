# ---------------------------------------------------------------------------
# Module: mongodb-local-mongod – Tabs
# ---------------------------------------------------------------------------

resource "terminal" "mongosh" {
  target = resource.container.mongodb
  shell  = "/bin/bash"
  # The mongodb-image ships /scripts/mongosh.sh which connects with the
  # correct connection string and auth credentials set during setup.
  cmd    = "/scripts/mongosh.sh"
}

resource "terminal" "bash" {
  target = resource.container.mongodb
  shell  = "/bin/bash"
}
