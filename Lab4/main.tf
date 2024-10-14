terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

resource "docker_network" "mynetwork" {
  name = "mynetwork"
}

# Create a web1 container
resource "docker_container" "web1" {
  image = var.image_name
  name  = "web1"
  networks_advanced {
    name = docker_network.mynetwork.name
  }
  command = [
    "-text=hello from web1"
  ]
}

# Create a web2 container
resource "docker_container" "web2" {
  image = var.image_name
  name  = "web2"
  networks_advanced {
    name = docker_network.mynetwork.name
  }
  command = [
    "-text=hello from web2"
  ]
}

# Create a web3 container
resource "docker_container" "web3" {
  image = var.image_name
  name  = "web3"
  networks_advanced {
    name = docker_network.mynetwork.name
  }
  command = [
    "-text=hello from web3"
  ]
}

#Create a haproxy1
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

  #Mount volume(read-only)
  volumes {
    host_path = "/home/vagrant/haproxy/share"
    container_path = "/usr/local/etc/haproxy"
    read_only = true
  }
}

#Create a haproxy2
resource "docker_container" "haproxy2" {
  image = "haproxytech/haproxy-alpine:2.4"
  name  = "haproxy2"
  networks_advanced {
    name = docker_network.mynetwork.name
  }
  ports {
    internal = 80
    external = 81
  }
  ports {
    internal = 8404
    external = 8405
  }

  #Mount volume(read-only)
  volumes {
    host_path = "/home/vagrant/haproxy/share"
    container_path = "/usr/local/etc/haproxy"
    read_only = true
  }
}

#Create VIP for two running haproxy
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
