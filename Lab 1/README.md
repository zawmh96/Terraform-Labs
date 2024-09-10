# Lab 1: Terraform Backend with S3 and DynamoDB

## Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Architecture Overview](#architecture-overview)
4. [Terraform Backend Configuration](#terraform-backend-configuration)
   - [S3 Backend](#s3-backend)
   - [DynamoDB State Locking](#dynamodb-state-locking)
5. [Setup Instructions](#setup-instructions)
   1. [Step 1: Create S3 Bucket](#step-1-create-s3-bucket)
   2. [Step 2: Enable S3 Versioning](#step-2-enable-s3-versioning)
   3. [Step 3: Create DynamoDB Table](#step-3-create-dynamodb-table)
   4. [Step 4: Configure Terraform Backend](#step-4-configure-terraform-backend)
   5. [Step 5: Initialize Terraform](#step-5-initialize-terraform)
   6. [Step 6: Apply the Configuration](#step-6-apply-the-configuration)
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

### Step 1: Create S3 Bucket

Use the AWS CLI or the AWS console to create an S3 bucket for storing the Terraform state file. Make sure the bucket has a unique name globally.

### Step 2: Enable S3 Versioning

Enable versioning for the S3 bucket to maintain a history of the state file. This ensures you can roll back to a previous version if needed.

### Step 3: Create DynamoDB Table

Create a DynamoDB table with a primary key of `LockID` to store the lock information for Terraform. This will prevent multiple users from modifying the same state at once.

### Step 4: Configure Terraform Backend

Update your `main.tf` file to include the following backend configuration:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-s3-bucket-name"
    key            = "terraform/state"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

### Step 5: Initialize Terraform
Run the following command to initialize the backend:
```
terraform init
```

### Step 6: Apply the Configuration
Apply the Terraform configuration to create and manage the backend resources:
```
terraform apply
```

### Cleaning Up Resources
After completing the lab, clean up the resources to avoid incurring charges. Use the following command to destroy the resources:
```
terraform destroy
```
