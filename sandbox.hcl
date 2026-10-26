# ---------------------------------------------------------------------------
# Module: aws-sandbox
# Packages the reusable AWS sandbox infrastructure:
#   - Sandboxed AWS account (AdministratorAccess + Bedrock)
#   - cloud_client container (AWS CLI)
#   - workstation container (Ubuntu 24.04)
#   - Network connecting the two containers
#   - Setup exec scripts
# ---------------------------------------------------------------------------

resource "network" "main" {
  subnet = "10.0.200.0/24"
}

resource "aws_account" "example" {
  regions = ["eu-west-2"]

  services = [
    "ec2",
    "s3",
    "iam",
    "bedrock",
    "ssm",
  ]

  tags = {
    Environment = "Lab"
    Purpose     = "AWS Sandbox Module"
  }

  user "student" {
    managed_policies = [
      "arn:aws:iam::aws:policy/AdministratorAccess",
      "arn:aws:iam::aws:policy/AmazonBedrockFullAccess",
    ]
  }
}

resource "container" "cloud_client" {
  image {
    name = "amazon/aws-cli:2.17.0"
  }

  entrypoint = ["/bin/bash"]
  command    = ["-c", "sleep infinity"]

  environment = {
    AWS_ACCESS_KEY_ID     = resource.aws_account.example.user.0.access_key_id
    AWS_SECRET_ACCESS_KEY = resource.aws_account.example.user.0.secret_access_key
    AWS_DEFAULT_REGION    = "eu-west-2"
    AWS_REGION            = "eu-west-2"
  }

  resources {
    cpu    = 1000
    memory = 1024
  }

  network {
    id = resource.network.main.meta.id
  }
}

resource "container" "workstation" {
  image {
    name = "ubuntu:24.04"
  }

  entrypoint = ["/bin/bash"]
  command    = ["-c", "sleep infinity"]

  environment = {
    AWS_ACCESS_KEY_ID     = resource.aws_account.example.user.0.access_key_id
    AWS_SECRET_ACCESS_KEY = resource.aws_account.example.user.0.secret_access_key
    AWS_DEFAULT_REGION    = "eu-west-2"
    AWS_REGION            = "eu-west-2"
    DEBIAN_FRONTEND       = "noninteractive"
  }

  resources {
    cpu    = 2000
    memory = 2048
  }

  network {
    id = resource.network.main.meta.id
  }
}

resource "exec" "cloud_client_setup" {
  target = resource.container.cloud_client
  script = "scripts/exec/cloud_client_setup/script.sh"

  environment = {
    INSTRUQT_RESOLVED_USER = resource.aws_account.example.user.0.username
  }

  timeout = "300s"
}

resource "exec" "workstation_setup" {
  target  = resource.container.workstation
  script  = "scripts/exec/workstation_setup/script.sh"
  timeout = "600s"
}
