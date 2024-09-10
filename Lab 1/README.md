
# Terraform S3 Backend with DynamoDB Locking

This project configures a **Terraform** backend using **AWS S3** for storing the state file and **DynamoDB** for state locking and consistency. Using S3 as a remote backend allows you to store the Terraform state file securely and efficiently, while DynamoDB ensures state locking to prevent multiple users from running conflicting operations simultaneously.

## Prerequisites

Before running this Terraform configuration, ensure you have the following:

- **Terraform** (v1.x or later)
- An **AWS** account with the necessary IAM permissions to:
  - Create and manage S3 buckets
  - Create and manage DynamoDB tables
- AWS CLI configured or environment variables set for authentication

## Features

- Remote state storage in an S3 bucket.
- State locking and consistency checks using a DynamoDB table.
- Modular and reusable Terraform code.

## Architecture

The setup consists of:
- **S3 Bucket**: Used for storing the Terraform state file.
- **DynamoDB Table**: Used to lock the state file and ensure that only one Terraform operation can run at a time.

## Terraform Backend Configuration

Below is the sample configuration to define the backend in Terraform:

```hcl
terraform {
  backend "s3" {
    bucket         = "<YOUR_S3_BUCKET_NAME>"
    key            = "terraform/state/terraform.tfstate"
    region         = "<YOUR_AWS_REGION>"
    dynamodb_table = "<YOUR_DYNAMODB_TABLE_NAME>"
    encrypt        = true
  }
}
