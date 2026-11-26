locals {
  labels = {
    owner      = var.owner
    course     = "AI381"
    lab        = "lab4"
    managed_by = "terraform"
  }
}

# Reuse an existing image. Do not rebuild or relabel Lab 2/3 images.
# Retain the image in Docker even when this Terraform resource is destroyed.
resource "docker_image" "api" {
  name         = "${var.image}:${var.image_tag}"
  keep_locally = true
}

# The image must launch FastAPI on 0.0.0.0:8000 using its existing entrypoint.
resource "docker_container" "api" {
  name  = var.container_name
  image = docker_image.api.image_id

  ports {
    internal = 8000
    external = var.published_port
    ip       = "127.0.0.1"
    protocol = "tcp"
  }

  dynamic "labels" {
    for_each = local.labels
    content {
      label = labels.key
      value = labels.value
    }
  }
}
