packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = "~> 1.0"
    }
  }
}

source "docker" "nginx_custom" {
  image  = "nginx:alpine"
  commit = true
}

build {
  name    = "nginx-custom"
  sources = ["source.docker.nginx_custom"]

  provisioner "file" {
    source      = "../index.html"
    destination = "/usr/share/nginx/html/index.html"
  }

  provisioner "shell" {
    inline = [
      "nginx -t"
    ]
  }

  post-processor "docker-tag" {
    repository = "nginx-custom"
    tag        = ["latest"]
  }
}
