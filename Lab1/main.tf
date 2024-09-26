#To test code changes
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
    always_run = "${timestamp()}" #To keep it run every time the terraform code is run.
  }
}
