resource "page" "match_and_group" {
  title   = "$match and $group Stages"
  layout  = module.sandbox.output.layout_default
  content = file("instructions/01-match-and-group.md")
}
