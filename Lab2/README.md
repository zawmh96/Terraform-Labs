# Lab 2: AWS Key Pair Creation with Terraform

## Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Provider Plugins](#provider-plugins)
4. [Resources Explanation](#resources-explanation)
   - [Locals Block](#locals-block)
   - [Random String Resource](#random-string-resource)
   - [TLS Private Key Resource](#tls-private-key-resource)
   - [AWS Key Pair Resource](#aws-key-pair-resource)
   - [Local File Resource](#local-file-resource)
5. [Terrafrom Function Explanation](#terraform-function-explanation)
6. [Setup Instructions](#setup-instructions)
7. [Conclusion](#conclusion)

---

## Introduction

This Terraform configuration creates an **AWS EC2 Key Pair** with a randomly generated deployment ID and a secure TLS private key. The private key is stored locally, and permissions are set to restrict access to the owner.

---

## Prerequisites

- **Terraform** (v1.x or later)
- **AWS CLI** installed and configured
- **IAM Permissions** to manage EC2 key pairs and tagging resources

---

## Provider Plugins

- hashicorp/aws: Manages AWS resources like EC2 instances, key pairs, S3 buckets, etc.<br>
- hashicorp/random: Generates random values, such as random strings, useful for dynamic naming.<br>
- hashicorp/tls: Creates TLS keys and certificates.<br>
- hashicorp/local: Manages local file operations, such as saving keys or running local commands.<br>

---

## Resources Explanation 
### Locals Block
```hcl
locals {
  deployment_id = lower("${var.deployment_name}-${random_string.suffix.result}")
}
```
deployment_id: A unique deployment ID created by appending a random string to the deployment_name.

### Random String Resource
```hcl
resource "random_string" "suffix" {
  length  = 8
  special = false
}
```
random_string.suffix: Generates an 8-character random string with no special characters, used to make the deployment ID unique.

### TLS Private Key Resource
```hcl
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
```
tls_private_key.ssh: Creates an RSA private key with 4096-bit encryption for secure access to EC2 instances.

### AWS Key Pair Resource
```hcl
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
```
- aws_key_pair.this: Creates an EC2 key pair in AWS with a name based on the deployment_id.<br>
- count: The key pair will be created only if var.create_ec2_ssh_keypair is true.<br>
- public_key: The public key is sourced from the generated TLS private key.<br>
- Tags: Tags are assigned to the key pair using a combination of a custom name and any common tags provided.<br>

### Local File Resource

```hcl
resource "local_file" "private_key" {
  content  = tls_private_key.ssh.private_key_openssh
  filename = "${path.root}/generated/${local.deployment_id}-key.pem"

  provisioner "local-exec" {
    command = "chmod 400 ${path.root}/generated/${local.deployment_id}-key.pem"
  }
}
```
- local_file.private_key: Saves the private key locally in the ***generated/*** folder with restricted permissions.<br>
- local-exec provisioner: Sets the file permissions to 400, restricting access to the owner.

---
## Terrafrom Function Explanation

**lower()**: This function converts the entire string to lowercase. <br>
**merge()**: This function merges several tag maps.<br>
**Conditional Logic (? :)** : This is a shorthand ***if-else*** syntax used in Terraform.<br>
  - It checks the value of var.create_ec2_ssh_keypair. If it is true, the count is set to 1, meaning the AWS Key Pair will be created. If false, the count is set to 0, and the resource won't be created.

---

## Setup Instructions

### Initialize Terraform:

Initialize the working directory and download the necessary providers:

```terraform init```

### Plan the Infrastructure:

Review the resources that will be created:

```terraform plan```

### Apply the Configuration:

Apply the Terraform configuration to create the key pair and save the private key:

```terraform apply```

### Access the Private Key:

The private key will be stored in the ***generated/*** directory with restricted permissions.

---

# Conclusion
This Terraform configuration allows you to create an AWS EC2 Key Pair with a unique deployment ID and securely store the private key locally. You can use this configuration as part of a larger infrastructure setup, or adapt it to manage key pairs for multiple environments.


