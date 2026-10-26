resource "page" "match_and_group" {
  title   = "$match and $group Stages"
  layout  = resource.layout.default
  content = file("instructions/01-match-and-group.md")
}
