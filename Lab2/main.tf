locals {
  deployment_id = lower("${var.deployment_name}-${random_string.suffix.result}")
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "this" {
  count = var.create_ec2_ssh_keypair ? 1 : 0

  key_name   = "${local.deployment_id}-key"
  public_key = tls_private_key.ssh.public_key_openssh

  tags = merge(
    { Name = "${var.friendly_name_prefix}-keypair" },
    { Name = var.ec2_ssh_keypair_name },
    var.common_tags
  ) 
}

resource "local_file" "private_key" {
  content  = tls_private_key.ssh.private_key_openssh
  filename = "${path.root}/generated/${local.deployment_id}-key.pem"

  provisioner "local-exec" {
    command = "chmod 400 ${path.root}/generated/${local.deployment_id}-key.pem"
  }
}
