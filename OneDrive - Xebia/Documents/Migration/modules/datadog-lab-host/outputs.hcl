# ---------------------------------------------------------------------------
# Module: datadog-lab-host – Outputs
# ---------------------------------------------------------------------------

output "container" { value = resource.container.lab_host }
output "terminal_lab_host" { value = resource.terminal.lab_host }
output "storedog_tab" { value = resource.external_website.storedog }
