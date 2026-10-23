# ---------------------------------------------------------------------------
# Module: aws-sandbox  –  Outputs
# Labs reference these as: module.<block>.output.<name>
# ---------------------------------------------------------------------------

output "cloud_client" {
  description = "The AWS CLI container (for task targets and terminal tabs)"
  value       = resource.container.cloud_client
}

output "workstation" {
  description = "The Ubuntu workstation container"
  value       = resource.container.workstation
}

output "terminal_cloud_cli" {
  description = "Terminal tab wired to the cloud_client container"
  value       = resource.terminal.cloud_cli
}

output "terminal_workstation" {
  description = "Terminal tab wired to the workstation container"
  value       = resource.terminal.workstation
}

output "aws_credentials_tab" {
  description = "Cloud credentials tab for the AWS account"
  value       = resource.cloud_credentials.aws
}

output "aws_console_tab" {
  description = "External website tab pointing at the AWS sign-in console"
  value       = resource.external_website.aws_console
}
