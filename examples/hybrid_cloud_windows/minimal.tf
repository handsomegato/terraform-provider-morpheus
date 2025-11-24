terraform {
  required_version = ">= 1.0"
  required_providers {
    morpheus = {
      source  = "gomorpheus/morpheus"
      version = "0.14.0"
    }
  }
}

# Minimal provider-only configuration.
# Supply either username/password OR access_token via variables or environment.
provider "morpheus" {
  url          = var.morpheus_url
  access_token = var.morpheus_access_token
  # If you prefer username/password instead, comment access_token and set:
  # username = var.morpheus_username
  # password = var.morpheus_password
  secure       = var.morpheus_secure
}

variable "morpheus_url" {
  description = "Morpheus base URL (e.g. https://morpheus.example.com)"
  type        = string
}

variable "morpheus_access_token" {
  description = "Morpheus API access token (preferred)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "morpheus_username" {
  description = "Morpheus username (alternative to access token)"
  type        = string
  default     = ""
}

variable "morpheus_password" {
  description = "Morpheus password (alternative to access token)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "morpheus_secure" {
  description = "Enable SSL certificate verification"
  type        = bool
  default     = true
}

# Simple data source call to verify connectivity (counts groups)
# Comment out if connectivity issues occur.
data "morpheus_groups" "all" {}

output "group_count" {
  description = "Number of groups returned (verifies connectivity)."
  value       = length(data.morpheus_groups.all.groups)
}
