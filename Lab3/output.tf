output "docker_image_name" {
  value = docker_container.nginx-web.name
}

output "docker_image_id" {
  value = docker_container.nginx-web.image
}

output "docker_external_port" {
  value = docker_container.nginx-web.ports[0].external
}