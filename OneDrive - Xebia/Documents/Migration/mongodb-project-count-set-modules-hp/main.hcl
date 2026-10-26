module "sandbox" {
  source = "../modules/mongodb-local-mongod"
}

resource "layout" "default" {
  content {
    type = "split-left"
    left {
      type    = "tabs"
      content = [module.sandbox.output.terminal_mongosh, module.sandbox.output.terminal_bash]
    }
    right {
      type = "instructions"
    }
    left_size = 67
  }
}

# ── Page 1: $project ────────────────────────────────────────────────────────

resource "page" "project_stage" {
  title  = "$project Stage"
  layout = resource.layout.default

  content = file("instructions/01-project.md")
}

resource "task" "check_project" {
  title  = "Use $project to shape documents"
  target = module.sandbox.output.container

  check {
    script  = "scripts/task/project/check.sh"
    timeout = "30s"
  }

  solve {
    script  = "scripts/task/project/solve.sh"
    timeout = "30s"
  }

  page = resource.page.project_stage
}

# ── Page 2: $set ────────────────────────────────────────────────────────────

resource "page" "set_stage" {
  title  = "$set Stage"
  layout = resource.layout.default

  content = file("instructions/02-set.md")
}

resource "task" "check_set" {
  title  = "Use $set to add a field"
  target = module.sandbox.output.container

  check {
    script  = "scripts/task/set/check.sh"
    timeout = "30s"
  }

  solve {
    script  = "scripts/task/set/solve.sh"
    timeout = "30s"
  }

  page = resource.page.set_stage
}

# ── Page 3: $count ──────────────────────────────────────────────────────────

resource "page" "count_stage" {
  title  = "$count Stage"
  layout = resource.layout.default

  content = file("instructions/03-count.md")
}

resource "task" "check_count" {
  title  = "Use $count to count documents"
  target = module.sandbox.output.container

  check {
    script  = "scripts/task/count/check.sh"
    timeout = "30s"
  }

  solve {
    script  = "scripts/task/count/solve.sh"
    timeout = "30s"
  }

  page = resource.page.count_stage
}

# ── Lab ─────────────────────────────────────────────────────────────────────

resource "lab" "main" {
  title     = "$project, $count, and $set Stages"
  timelimit = "20m"

  page { ref = resource.page.project_stage }
  page { ref = resource.page.set_stage }
  page { ref = resource.page.count_stage }
}
