# How to deploy HAproxy with Docker Using Terraform

This repository contains a Terraform configuration to deploy multiple HAProxy containers with Docker. The setup includes three web server containers and two HAProxy instances, with IPVS for load balancing between the HAProxy containers.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Architecture](#architecture)
3. [Configuration](#configuration)
   - [Terraform Provider](#terraform-provider)
   - [Resources Defined](#resources-defined)
     - [Docker Network](#docker-network)
     - [Web Server Containers](#web-server-containers)
     - [HAProxy Containers](#haproxy-containers)
     - [Virtual IP (VIP) Setup](#virtual-ip-vip-setup)
4. [Initialize Terraform and Apply the code](#initialize-terraform-and-apply-the-code)
5. [Accessing the Application](#accessing-the-application)

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your machine.
- [Docker](https://docs.docker.com/get-docker/) installed and running.
- Basic knowledge of Terraform and Docker.
- A Linux environment to run the provisioning scripts (the example uses `sudo` commands).

## Architecture

The architecture consists of three web server containers and two HAProxy containers that balance traffic between them. The HAProxy containers are configured with a Virtual IP (VIP) that routes incoming requests. Below is a diagram illustrating the setup:

![image](https://github.com/user-attachments/assets/b59cd6a2-7bd6-4ba8-bf07-8b42d72f2cce)


## Configuration

### Terraform Provider

This configuration uses the Docker provider from `kreuzwerker`. Ensure you have the required provider specified in your `terraform` block:

```hcl
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}
```

### Resources Defined
#### Docker Network

A Docker network named mynetwork is created for the containers to communicate.
```
resource "docker_network" "mynetwork" {
  name = "mynetwork"
}
```

#### Web Server Containers

Three web server containers (web1, web2, and web3) are created using the specified Docker image. Each container responds with a unique message.
```
resource "docker_container" "web1" {
  image = var.image_name
  name  = "web1"
  networks_advanced {
    name = docker_network.mynetwork.name
  }
  command = ["-text=hello from web1"]
}
```

#### HAProxy Containers

Two HAProxy containers (haproxy1 and haproxy2) are created, each mapping different ports for external access.
```
resource "docker_container" "haproxy1" {
  image = "haproxytech/haproxy-alpine:2.4"
  name  = "haproxy1"
  networks_advanced {
    name = docker_network.mynetwork.name
  }
  ports {
    internal = 80
    external = 80
  }
  ports {
    internal = 8404
    external = 8404
  }
  volumes {
    host_path = "/home/vagrant/haproxy/share"
    container_path = "/usr/local/etc/haproxy"
    read_only = true
  }
}
```

#### Virtual IP (VIP) Setup

A null_resource is used to set up a Virtual IP for load balancing. This requires ipvsadm to be installed and configures the load balancer to distribute traffic between the two HAProxy containers.
```
resource "null_resource" "vip_setup" {
  provisioner "local-exec" {
    command = <<EOT
      sudo apt-get install -y ipvsadm && \
      sudo ipvsadm -A -t 192.168.100.10:80 -s rr && \
      sudo ipvsadm -a -t 192.168.100.10:80 -r ${docker_container.haproxy1.network_data[0].ip_address}:80 -m && \
      sudo ipvsadm -a -t 192.168.100.10:80 -r ${docker_container.haproxy2.network_data[0].ip_address}:80 -m && \
      sudo ipvsadm -l
    EOT
  }
}
```

## Initialize Terraform and Apply the code
```
terrafrom init
terrafrom validate
terrafrom plan
terraform apply
```

## Accessing the Application

Once the deployment is complete, you can access the web servers using the Virtual IP (VIP) configured with IPVS. The VIP is set to 192.168.100.10. Access the application by navigating to the following URL:

For load-balanced access, use http://192.168.100.10:80.  
This VIP will distribute the incoming traffic among the available HAProxy containers (haproxy1 and haproxy2), which in turn balance the requests to the web servers (web1, web2, and web3). You should see responses from the web containers indicating which one handled the request.
