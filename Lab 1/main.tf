
terraform {
  required_version = ">= 0.11.0"
  backend "s3" {
    bucket = "terraform-state-s3-12301"
    region = "ap-northeast-1"
    key = "terraform.tfstate"
    encrypt = true
    profile  = "dev-programmatic-admin-role"
    dynamodb_table = "terraform_state_lock"
  }
}

locals {
  pod_id = lower("${var.pod_name}-${random_string.suffix.result}")
  rds_creds = {
    username = var.rds_username
    password = var.rds_password
  }
}

resource "random_string" "suffix" {
  length  = 25
  special = false
}

resource "null_resource" "test_lock" {
  provisioner "local-exec" {
    command = "sleep 60"
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}