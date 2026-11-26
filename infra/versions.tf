terraform {
  required_version = ">= 1.9, < 2.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.7.0"
    }
  }

  # State remains in this working directory; never commit it.
  backend "local" {}
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}
