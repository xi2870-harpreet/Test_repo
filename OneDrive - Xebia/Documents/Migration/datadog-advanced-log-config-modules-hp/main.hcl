# ---------------------------------------------------------------------------
# Labs 2.0 migration of: course-advanced-log-configuration
#
# BLOCKER: The original track uses a GCP VM image:
#   datadog-community/generic-course-1-0-0
# This is not a Docker image. Labs 2.0 uses containers, not VMs.
#
# ACTION REQUIRED (Datadog team):
# 1. Build a Docker image from the generic-course VM image contents.
# 2. Push to a registry accessible from Instruqt.
# 3. Update the module source reference once the image is published.
#
# This file is a structural stub showing the correct Labs 2.0 pattern.
# All layout, page and task wiring is complete — only the container image
# is a placeholder.
# ---------------------------------------------------------------------------

module "sandbox" {
  source = "../modules/datadog-lab-host"
}

resource "layout" "default" {
  content {
    type = "split-left"
    left {
      type    = "tabs"
      content = [module.sandbox.output.terminal_lab_host, module.sandbox.output.storedog_tab]
    }
    right {
      type = "instructions"
    }
    left_size = 60
  }
}

resource "page" "collecting_logs" {
  title   = "Collecting Logs Across Files"
  layout  = resource.layout.default
  content = file("instructions/01-collecting-logs.md")
}

resource "page" "multiline_logs" {
  title   = "Multiline Logs"
  layout  = resource.layout.default
  content = file("instructions/02-multiline-logs.md")
}

resource "page" "processing_rules" {
  title   = "Processing Rules"
  layout  = resource.layout.default
  content = file("instructions/03-processing-rules.md")
}

resource "page" "filtering_logs" {
  title   = "Filtering Logs"
  layout  = resource.layout.default
  content = file("instructions/04-filtering-logs.md")
}

resource "lab" "main" {
  title     = "Advanced Log Configuration"
  timelimit = "2h"

  page { ref = resource.page.collecting_logs }
  page { ref = resource.page.multiline_logs }
  page { ref = resource.page.processing_rules }
  page { ref = resource.page.filtering_logs }
}
