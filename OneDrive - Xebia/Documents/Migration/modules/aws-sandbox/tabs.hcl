# ---------------------------------------------------------------------------
# Module: aws-sandbox  –  Tabs
# These are the reusable tab resources exposed by the module.
# Labs reference them via module.<block>.output.<name>
# ---------------------------------------------------------------------------

resource "terminal" "cloud_cli" {
  target = resource.container.cloud_client
  shell  = "/bin/bash"
}

resource "terminal" "workstation" {
  target = resource.container.workstation
  shell  = "/bin/bash"
}

resource "cloud_credentials" "aws" {
  aws_account {
    target = resource.aws_account.example
    users  = ["student"]
  }
}

resource "external_website" "aws_console" {
  url                = "https://signin.aws.amazon.com/console"
  open_in_new_window = true
}
