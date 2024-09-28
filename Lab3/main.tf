terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

# Pull Docker image 
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