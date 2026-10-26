# ---------------------------------------------------------------------------
# Lab: $project, $count, and $set Stages (Labs 2.0 migration)
# All sandbox, tabs, layout, pages and activities are in the module.
# This file is the entire lab definition.
# ---------------------------------------------------------------------------

module "track" {
  source = "../modules/project-count-set-stages"
}

resource "lab" "main" {
  title     = "$project, $count, and $set Stages"
  timelimit = "20m"

  page { ref = module.track.output.page_project }
  page { ref = module.track.output.page_set }
  page { ref = module.track.output.page_count }
}
