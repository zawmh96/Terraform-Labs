# Lab 1: Terraform Backend with S3 and DynamoDB

## Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Architecture Overview](#architecture-overview)
4. [Setup Instructions](#setup-instructions)
   1. [Step 1: Create S3 Bucket with version enable](#step-1-create-s3-bucket-with-version-enable)
   2. [Step 2: Create DynamoDB Table](#step-2-create-dynamodb-table)
   3. [Step 3: Configure Terraform Backend with S3](#step-3-configure-terraform-backend-with-s3)
   4. [Step 4: Initialize Terraform and apply the Configuration](#step-4-initialize-terraform-and-apply-the-configuration)
   5. [Step 5: Check the state file stored in S3 bucket](#step-5-check-the-state-file-stored-in-S3-bucket)
   6. [Step 6: Add DynamoDB in Terraform Backend for state lock](#step-6-add-dynamodb-in-terraform-backend-for-state-lock)
   7. [Step 7: Reinitialize Terraform and apply the Configuration](#step-7-reinitialize-terraform-and-apply-the-configuration)
   8. [Step 8: Check the latest state file stored in S3 bucket and items in DynamoDB table](#step-8-check-the-latest-state-file-stored-in-S3-bucket-and-items-in-dynamodb-table)
   9. [Step 9: Validate the state lock for preventing any concurrent operations](#step-9-validate-the-state-lock-for-preventing-any-concurrent-operations)
5. [Conclusion](#conclusion)

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

![image](https://github.com/user-attachments/assets/1caff391-3f8b-49cf-ba85-6debbbbc51e6)

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
    --region ap-northeast-1
```

### Step 3: Configure Terraform Backend with S3

Update your `main.tf` file to include the following backend configuration:

```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state-s3-12301"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
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
![image](https://github.com/user-attachments/assets/14a797de-4266-4010-b462-cf2b805469bf)


### Step 5: Check the state file stored in S3 bucket
Use AWS CLI or GUI to check the state files in S3 bucket.

![image](https://github.com/user-attachments/assets/ada34f33-0309-430c-85a7-2a422d71e55f)


### Step 6: Add DynamoDB in Terraform Backend for state lock
Update your `main.tf` file to include dynamoDB table in the backend configuration:
```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state-s3-12301"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks" #Add this line for state lock
  }
}
```

### Step 7: Reinitialize Terraform and apply the Configuration
Make a chages in local random string before apply the configuration.  
Run the following command to reinitialize the backend and apply the Terraform configuration to create and manage the backend resources and as well in DynamoDB table:

```
terraform init
terraform apply
```

![image](https://github.com/user-attachments/assets/f74a60fe-d95b-4261-9340-49b4867087c0)


### Step 8: Check the latest state file stored in S3 bucket and items in DynamoDB table

![image](https://github.com/user-attachments/assets/14401408-6940-4622-8ced-491b1468b7cc)


![image](https://github.com/user-attachments/assets/d9208737-1a20-4c46-8846-3fc7fa936c52)

### Step 9: Validate the state lock for preventing any concurrent operations

Make a change in length from 10 to 20 and apply the configuration from one terminal.   
While runing in the terminal, make another change and apply it at another terminal.  

You will not able to apply in second terminal as the state is in lock.

![image](https://github.com/user-attachments/assets/889a50ba-6d64-4ee2-a5ca-0e113360da47)

---
### Conclusion
By the end of this lab, you will have successfully configured a remote backend for Terraform using S3 and DynamoDB for state locking. This configuration ensures collaboration and consistency across your infrastructure deployments.
