# Lab 2: AWS EC2 Key Pair Creation with Terraform

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
   6. [Step 6: Validate the concurrent operation at the same time](#step-6-validate-the-concurrent-operation-at-the-same-time)
   7. [Step 7: Add DynamoDB in Terraform Backend for state lock](#step-7-add-dynamodb-in-terraform-backend-for-state-lock)
   8. [Step 8: Reinitialize Terraform and apply the Configuration](#step-8-reinitialize-terraform-and-apply-the-configuration)
   9. [Step 9: Check the latest state file stored in S3 bucket and items in DynamoDB table](#step-9-check-the-latest-state-file-stored-in-S3-bucket-and-items-in-dynamodb-table)
   10. [Step 10: Validate the concurrent operation at the same time after adding DynamoDB](#step-10-validate-the-concurrent-operation-at-the-same-time-after-adding-dynamodb)
5. [Conclusion](#conclusion)

---