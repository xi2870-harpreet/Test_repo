resource "activity" "check_match_group" {
  title  = "Run the aggregation pipeline with $match and $group"
  target = resource.container.mongodb

  check {
    script  = "scripts/activity/check.sh"
    timeout = "30s"
  }

  solve {
    script  = "scripts/activity/solve.sh"
    timeout = "30s"
  }

  page = resource.page.match_and_group
}
