# ---------------------------------------------------------------------------
# Module: mongodb-local-mongod – Default Layout
# AssignmentRight 67/33: terminals on left, instructions on right.
# Exposed as an output so consuming modules can reference it.
# ---------------------------------------------------------------------------

resource "layout" "assignment_right" {
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
