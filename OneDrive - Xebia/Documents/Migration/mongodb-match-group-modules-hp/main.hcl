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

resource "page" "match_and_group" {
  title  = "$match and $group Stages"
  layout = resource.layout.default

  content = file("instructions/01-match-and-group.md")
}

resource "task" "check_match_group" {
  title  = "Run the aggregation pipeline"
  target = module.sandbox.output.container

  check {
    script  = "scripts/task/match_group/check.sh"
    timeout = "30s"
  }

  solve {
    script  = "scripts/task/match_group/solve.sh"
    timeout = "30s"
  }

  page = resource.page.match_and_group
}

resource "lab" "main" {
  title    = "$match and $group Stages"
  timelimit = "20m"

  page { ref = resource.page.match_and_group }
}
