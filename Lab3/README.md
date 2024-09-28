# Creating a Nginx Docker Image and Deploying Docker Application Using Terraform

This project demonstrates how to build a Docker image for an Nginx web server, push the image to Docker Hub, and deploy a Docker application using Terraform.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Steps](#steps)
  - [1. Build the Nginx Docker Image](#1-build-the-nginx-docker-image)
  - [2. Push the Image to Docker Hub](#2-push-the-image-to-docker-hub)
  - [3. Deploy the Docker Application Using Terraform](#3-deploy-the-docker-application-using-terraform)
  - [4. Initialize and Apply Terraform](#initialize-and-apply-terraform)
- [Conclusion](#conclusion)

## Prerequisites

Before you start, ensure you have the following tools installed:

- Docker
- Docker Hub account
- Terraform (v1.x or later)

## Steps

### 1. Build the Nginx Docker Image

You will first need to create a Dockerfile that specifies the configuration for the Nginx Docker image.

Create a `Dockerfile`:

```Dockerfile
FROM nginx:1.21
COPY index.html /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
```

Now, to build the Docker image, run the following command:
```
docker build -t custom-nginx .
```

---

### 2. Push the Image to Docker Hub
Once the image is built, log in to Docker Hub:
```
docker login -u zawminhtay
```

After logging in, push the Docker image to Docker Hub:
```
docker push zawminhtay/custom-nginx:latest
```

---

### 3. Deploy the Docker Application Using Terraform

Create a terraform code files.

Below is main.tf for creating docker container

```
resource "docker_image" "nginx" {
  name = var.image_name
}

# Create a container
resource "docker_container" "nginx-web" {
  image = docker_image.nginx.image_id
  name  = var.docker_name
  ports {
    internal = var.internal_port
    external = var.external_port
  }
}
```

---

### 4. Initialize and Apply terrform

#### Initialize Terraform:

Initialize the working directory and download the necessary providers:

```terraform init```

#### Plan the Infrastructure:

Review the resources that will be created:

```terraform plan```

#### Apply the Configuration:

Apply the Terraform configuration to create the key pair and save the private key:

```terraform apply```

#### Check docker container running in local:

```docker ps```

---

## Conclusion
This project demonstrates how to build and deploy a Dockerized Nginx application using Docker and Terraform. By following these steps, you will have successfully created a Docker image, pushed it to Docker Hub, and deployed it using Terraform.
