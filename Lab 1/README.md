# Lab 1: Terraform Backend with S3 and DynamoDB

## Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Architecture Overview](#architecture-overview)
4. [Terraform Backend Configuration](#terraform-backend-configuration)
   - [S3 Backend](#s3-backend)
   - [DynamoDB State Locking](#dynamodb-state-locking)
5. [Setup Instructions](#setup-instructions)
   1. [Step 1: Create S3 Bucket with version enable](#step-1-create-s3-bucket-with-version-enable)
   2. [Step 2: Create DynamoDB Table](#step-3-create-dynamodb-table)
   4. [Step 3: Configure Terraform Backend](#step-3-configure-terraform-backend)
   5. [Step 4: Initialize Terraform and apply the Configuration](#step-4-initialize-terraform-and-apply-the-configuration)
6. [Cleaning Up Resources](#cleaning-up-resources)
7. [IAM Permissions](#iam-permissions)
8. [Conclusion](#conclusion)

---

## Introduction

In this lab, we will configure a Terraform backend using **S3** to store the state file and **DynamoDB** for state locking. This setup ensures that your infrastructure state is consistently stored and locked, preventing any concurrent operations from corrupting the state.

---

## Prerequisites

- Terraform (v1.x or later)
- AWS CLI installed and configured with appropriate permissions
- AWS account with access to S3 and DynamoDB

---

## Architecture Overview

The Terraform backend uses an **S3 bucket** to store the Terraform state files, while **DynamoDB** is used to provide state locking, ensuring that only one process can modify the state at a time.

---

## Terraform Backend Configuration

This section explains how to configure the S3 bucket and DynamoDB for Terraform backend storage.

### S3 Backend

The S3 bucket stores the Terraform state files. The state file holds the current state of the resources managed by Terraform, and storing it remotely allows for collaboration across teams.

### DynamoDB State Locking

DynamoDB is used to lock the state file, preventing multiple users from making changes to the infrastructure at the same time.

---

## Setup Instructions

### Step 1: Create S3 Bucket with version enable

Use the AWS CLI or the AWS console to create an S3 bucket for storing the Terraform state file. Make sure the bucket has a unique name globally.
Enable versioning for the S3 bucket to maintain a history of the state file. This ensures you can roll back to a previous version if needed.
```
# Create the S3 bucket
aws s3api create-bucket --bucket terraform-state-s3-12301 --region ap-northeast-1 --create-bucket-configuration LocationConstraint=ap-northeast-1

# Enable versioning on the bucket
aws s3api put-bucket-versioning --bucket terraform-state-s3-12301 --versioning-configuration Status=Enabled
```

### Step 2: Create DynamoDB Table

Create a DynamoDB table with a primary key of `LockID` to store the lock information for Terraform. This will prevent multiple users from modifying the same state at once.
```
aws dynamodb create-table \
    --table-name terraform-state-locks \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --region <your-region>
```

### Step 3: Configure Terraform Backend

Update your `main.tf` file to include the following backend configuration:

```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state-s3-12301"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
```

### Step 4: Initialize Terraform and Apply the Configuration
Run the following command to initialize the backend and apply the Terraform configuration to create and manage the backend resources:
```
terraform init
terraform apply
```

### Cleaning Up Resources
After completing the lab, clean up the resources to avoid incurring charges. Use the following command to destroy the resources:
```
terraform destroy
```
