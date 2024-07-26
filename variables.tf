variable "project" {
  default = "pommy"
  description = "The project name"
}

variable "environment" {
  default = "dev"
  description = "The environment to release"
}

variable "location" {
  default = "East US 2"
  description = "Azure region"
}

variable "tags" {
  default = {
    environment = "dev"
    project = "pommy"
    created_by = "terraform"
  }
  description = "All tags used"
}

variable "password" {
  description = "SQl Server password"
  type = string
  sensitive = true
}
