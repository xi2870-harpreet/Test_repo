# ---------------------------------------------------------------------------
# Lab: $match and $group Stages (Labs 2.0 migration)
# All sandbox, tabs, layout, page and activity are in the module.
# This file is the entire lab definition.
# ---------------------------------------------------------------------------

module "track" {
  source = "../modules/match-and-group-stages"
}

resource "lab" "main" {
  title     = "$match and $group Stages"
  timelimit = "20m"

  page { ref = module.track.output.page_match_and_group }
}
