# ---------------------------------------------------------------------------
# Module: match-and-group-stages
# Fat module: nests mongodb-local-mongod for sandbox/tabs/layout,
# then adds the page and activity for this specific track.
# Lab files only need the `lab` resource.
# ---------------------------------------------------------------------------

module "sandbox" {
  source = "../mongodb-local-mongod"
}
