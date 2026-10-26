resource "page" "project_stage" {
  title   = "$project Stage"
  layout  = resource.layout.default
  content = file("instructions/01-project.md")
}

resource "page" "set_stage" {
  title   = "$set Stage"
  layout  = resource.layout.default
  content = file("instructions/02-set.md")
}

resource "page" "count_stage" {
  title   = "$count Stage"
  layout  = resource.layout.default
  content = file("instructions/03-count.md")
}
