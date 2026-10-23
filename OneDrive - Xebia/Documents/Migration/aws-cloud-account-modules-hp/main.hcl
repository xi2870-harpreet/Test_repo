# ---------------------------------------------------------------------------
# Module block – pulls in the reusable AWS sandbox
#
# In a real workflow you would publish the aws-sandbox module to the registry
# first and reference it as:
#   source  = "instruqt-support/aws-sandbox"
#   version = "~> 1.0"
#
# For local development (before publishing) the source is a relative path.
# ---------------------------------------------------------------------------
module "sandbox" {
  source = "../modules/aws-sandbox"
}

# ---------------------------------------------------------------------------
# Layouts
# ---------------------------------------------------------------------------
resource "layout" "default" {
  column {
    width = "67"

    tab "cloud_cli" {
      title  = "Cloud CLI"
      target = module.sandbox.output.terminal_cloud_cli
      active = true
    }

    tab "aws_credentials" {
      title  = "AWS Console"
      target = module.sandbox.output.aws_credentials_tab
    }

    tab "aws_console" {
      title  = "AWS Console (Browser)"
      target = module.sandbox.output.aws_console_tab
    }

    tab "workstation" {
      title  = "Ubuntu"
      target = module.sandbox.output.terminal_workstation
    }
  }

  column {
    width = "33"

    instructions {
      title  = "Instructions"
      active = true
    }
  }
}

resource "layout" "console_only" {
  column {
    width = "67"

    tab "aws_credentials" {
      title  = "AWS Console"
      target = module.sandbox.output.aws_credentials_tab
      active = true
    }

    tab "aws_console" {
      title  = "AWS Console (Browser)"
      target = module.sandbox.output.aws_console_tab
    }

    tab "cloud_cli" {
      title  = "Cloud CLI"
      target = module.sandbox.output.terminal_cloud_cli
    }
  }

  column {
    width = "33"

    instructions {
      title  = "Instructions"
      active = true
    }
  }
}

# ---------------------------------------------------------------------------
# Tasks
# ---------------------------------------------------------------------------
resource "task" "create_ec2" {
  description     = "Create an EC2 instance with the AWS CLI"
  success_message = "Nice - your EC2 instance is up."

  config {
    target  = module.sandbox.output.cloud_client
    timeout = "120s"
  }

  condition "instance_exists" {
    description = "Launch a t2.nano EC2 instance"

    check {
      script          = "scripts/task/create_ec2/check.sh"
      failure_message = "Please create an instance to proceed"
    }

    solve {
      script = "scripts/task/create_ec2/solve.sh"
    }
  }
}

resource "task" "delete_ec2" {
  description     = "Terminate the EC2 instance you created"
  success_message = "Instance terminated - the account is clean again."

  config {
    target  = module.sandbox.output.cloud_client
    timeout = "120s"
  }

  condition "instance_terminated" {
    description = "Terminate the running EC2 instance"

    check {
      script          = "scripts/task/delete_ec2/check.sh"
      failure_message = "Please terminate instance to proceed"
    }

    solve {
      script = "scripts/task/delete_ec2/solve.sh"
    }
  }
}

# ---------------------------------------------------------------------------
# Pages
# ---------------------------------------------------------------------------
resource "page" "create_ec2" {
  title = "Create an AWS EC2 instance"
  file  = "instructions/01-create-ec2.md"

  activities = {
    create_ec2 = resource.task.create_ec2
  }
}

resource "page" "delete_ec2" {
  title = "AWS EC2 instance deletion"
  file  = "instructions/02-delete-ec2.md"

  activities = {
    delete_ec2 = resource.task.delete_ec2
  }
}

# ---------------------------------------------------------------------------
# Lab
# ---------------------------------------------------------------------------
resource "lab" "main" {
  title = "AWS Cloud Account (with Modules)"

  description = <<-EOT
    Learn how to use a sandboxed AWS account in your Instruqt lab.

    **This lab demonstrates how to:**
      - Pull shared sandbox infrastructure from a module
      - Link an AWS cloud account to your sandbox
      - Use the AWS CLI and console from the lab environment
      - Limit usage of the cloud account using IAM and SCP policies

    The default settings only allow t2.nano sized EC2 instances.
    Adjust the IAM policy to fit your own use case and application size.
  EOT

  settings {
    timelimit {
      duration   = "5h"
      show_timer = true
    }

    controls {
      show_stop = true
    }
  }

  layout = resource.layout.default

  content {
    chapter "create" {
      title = "Create an AWS EC2 instance"

      page "create_ec2" {
        reference = resource.page.create_ec2
      }
    }

    chapter "delete" {
      title  = "AWS EC2 instance deletion"
      layout = resource.layout.console_only

      page "delete_ec2" {
        reference = resource.page.delete_ec2
      }
    }
  }
}
