# Terraform-Labs

1. **Lab 1 - Terraform Backend with S3 and DynamoDB**:
   - In this lab, you'll configure a remote backend for Terraform using S3 to store the state file and DynamoDB for state locking. This ensures consistency and prevents concurrent operations.
   - [Read more here](Lab1/README.md)

2. **Lab 2 - AWS EC2 Key Pair Creation with Terraform**:
   - In this lab, you'll configure AWS EC2 Key pair using terraform. Pubilc key will be stored in AWS account and private key in locally.
   - [Read more here](Lab2/README.md)
  
3. **Lab 3 - Creating a Nginx Docker Image and Deploying Docker Application Using Terraform**:
   - In this lab, demonstrates how to build a Docker image for an Nginx web server, push the image to Docker Hub, and deploy a Docker application using Terraform.
   - [Read more here](Lab3/README.md)
  

## How to Use This Repository

Each lab is self-contained and can be executed independently. Follow the steps below to get started:

### Prerequisites

- **Terraform** (v1.x or later) installed on your local machine.
- AWS credentials configured either via environment variables or AWS CLI.
- Basic understanding of Terraform and AWS.

### Setup Instructions

1. **Clone the Repository**

   First, clone this repository to your local machine:

   ```bash
   git clone https://github.com/yourusername/terraform-labs.git
   cd terraform-labs
