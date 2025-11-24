# Morpheus provider configuration variables
variable "morpheus_url" {
  description = "The URL of the Morpheus platform"
  type        = string
  validation {
    condition     = can(regex("^https?://", var.morpheus_url))
    error_message = "The Morpheus URL must start with http:// or https://."
  }
}

variable "morpheus_username" {
  description = "The username for Morpheus authentication"
  type        = string
}

variable "morpheus_password" {
  description = "The password for Morpheus authentication"
  type        = string
  sensitive   = true
}

variable "morpheus_access_token" {
  description = "The access token for Morpheus authentication (alternative to username/password)"
  type        = string
  sensitive   = true
  default     = null
}

variable "morpheus_tenant_subdomain" {
  description = "The tenant subdomain for multi-tenant environments"
  type        = string
  default     = null
}

variable "morpheus_secure" {
  description = "Enable SSL certificate verification"
  type        = bool
  default     = true
}

# Infrastructure variables
variable "group_name" {
  description = "The name of the Morpheus group"
  type        = string
  default     = "Default"
}

variable "cloud_name" {
  description = "The name of the cloud to deploy to"
  type        = string
}

variable "network_name" {
  description = "The name of the network to use"
  type        = string
}

variable "resource_pool_name" {
  description = "The name of the resource pool"
  type        = string
}

variable "plan_name" {
  description = "The name of the service plan"
  type        = string
  default     = "T3 Small - 2 Core, 2GB Memory"
}

variable "provision_type" {
  description = "The provision type for the plan"
  type        = string
  default     = "Amazon EC2"
}

# Instance variables
variable "instance_name" {
  description = "The name of the instance to create"
  type        = string
  
  validation {
    condition     = length(var.instance_name) >= 3 && length(var.instance_name) <= 50
    error_message = "Instance name must be between 3 and 50 characters."
  }
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "terraform-demo"
}

variable "api_key" {
  description = "API key for the application"
  type        = string
  sensitive   = true
  default     = ""
}

# User management variables
variable "new_username" {
  description = "Username for new user creation"
  type        = string
  default     = ""
}

variable "first_name" {
  description = "First name of the user"
  type        = string
  default     = ""
}

variable "last_name" {
  description = "Last name of the user"
  type        = string
  default     = ""
}

variable "email" {
  description = "Email address of the user"
  type        = string
  default     = ""
  
  validation {
    condition     = var.email == "" || can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.email))
    error_message = "Email must be a valid email address."
  }
}

variable "user_password" {
  description = "Password for the new user"
  type        = string
  sensitive   = true
  default     = ""
}

variable "role_id" {
  description = "Role ID for the new user"
  type        = number
  default     = 0
}

variable "new_group_name" {
  description = "Name for the new group"
  type        = string
  default     = ""
}

variable "group_location" {
  description = "Location for the new group"
  type        = string
  default     = ""
}

# Environment variables
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}