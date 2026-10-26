# ---------------------------------------------------------------------------
# Module: datadog-lab-host – Tabs
# ---------------------------------------------------------------------------

resource "terminal" "lab_host" {
  target = resource.container.lab_host
  shell  = "/bin/bash"
}

# The original tracks expose Storedog/web apps via external_website.
# The URL is dynamic (injected at runtime via STOREDOG_URL variable).
# Replace the url below with the lab's dynamic URL once supported.
resource "external_website" "storedog" {
  url                = "https://placeholder.env.play.instruqt.com"
  open_in_new_window = true
}
