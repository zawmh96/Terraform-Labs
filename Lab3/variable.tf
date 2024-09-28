variable "image_name" {
  description = "Docker image name from docker hub"
  default = "zawminhtay/custom-nginx"
}

variable "docker_name" {
  description = "Docker name to deploy"
  default = "nginx-web"
}

variable "internal_port" {
  description = "Internal port of docker application"
  type = number
  default = 80
}

variable "external_port" {
  description = "External port of docker application to access from outside"
  type = number
  default = 9090
}