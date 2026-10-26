# ---------------------------------------------------------------------------
# Module: mongodb-local-mongod – Tabs
# ---------------------------------------------------------------------------

resource "terminal" "mongosh" {
  target = resource.container.mongodb
  shell  = "/bin/bash"
  cmd    = "mongosh"
}

resource "terminal" "bash" {
  target = resource.container.mongodb
  shell  = "/bin/bash"
}
