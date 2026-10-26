# ---------------------------------------------------------------------------
# Module: mongodb-local-mongod – Outputs
# Labs reference these via: module.<block>.output.<name>
# ---------------------------------------------------------------------------

output "container"         { value = resource.container.mongodb }
output "terminal_mongosh"  { value = resource.terminal.mongosh }
output "terminal_bash"     { value = resource.terminal.bash }
output "layout_default"    { value = resource.layout.assignment_right }
