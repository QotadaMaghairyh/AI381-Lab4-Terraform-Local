variable "image" {
  description = "Existing Customer Churn FastAPI image repository/name, without its tag."
  type        = string

  validation {
    condition     = length(trimspace(var.image)) > 0
    error_message = "Provide a nonempty image repository/name."
  }
}

variable "image_tag" {
  description = "Tag of the existing image; no image is built by this configuration."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_][A-Za-z0-9_.-]{0,127}$", var.image_tag))
    error_message = "Provide a valid Docker image tag."
  }
}

variable "container_name" {
  description = "Unique name for the Lab 4 container, separate from existing Lab 2/3 containers."
  type        = string
  default     = "ai381-lab4-churn-api"

  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9_.-]+$", var.container_name))
    error_message = "Use at least two characters: letters, digits, underscores, periods or hyphens; begin with a letter or digit."
  }
}

variable "published_port" {
  description = "Localhost TCP port mapped to the application's internal port 8000."
  type        = number
  default     = 8000

  validation {
    condition     = var.published_port >= 1024 && var.published_port <= 65535 && floor(var.published_port) == var.published_port
    error_message = "Use an integer port between 1024 and 65535."
  }
}

variable "owner" {
  description = "Name or GitHub username recorded in ownership labels."
  type        = string

  validation {
    condition     = length(trimspace(var.owner)) > 0
    error_message = "Provide a nonempty owner name."
  }
}
