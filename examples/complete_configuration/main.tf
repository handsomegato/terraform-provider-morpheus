terraform {
  required_version = ">= 1.0"
  required_providers {
    morpheus = {
      source  = "gomorpheus/morpheus"
      version = "0.14.0"
    }
  }
}

# Provider configuration with authentication options
provider "morpheus" {
  # Option 1: Using username/password authentication
  url      = var.morpheus_url
  username = var.morpheus_username
  password = var.morpheus_password
  
  # Option 2: Using access token (uncomment to use)
  # access_token = var.morpheus_access_token
  
  # Option 3: Using client credentials with tenant subdomain
  # username         = var.morpheus_username
  # password         = var.morpheus_password
  # tenant_subdomain = var.morpheus_tenant_subdomain
  
  # Security settings
  secure = var.morpheus_secure # Set to false to disable SSL verification for self-signed certificates
}

# Example data sources
data "morpheus_group" "default_group" {
  name = var.group_name
}

data "morpheus_cloud" "target_cloud" {
  name = var.cloud_name
}

data "morpheus_environment" "dev" {
  name = "development"
}

# Example instance type and layout
data "morpheus_instance_type" "ubuntu" {
  name = "Ubuntu"
}

data "morpheus_instance_layout" "ubuntu_layout" {
  name    = "Amazon VM"
  version = "22.04"
}

# Example plan
data "morpheus_plan" "small" {
  name           = var.plan_name
  provision_type = var.provision_type
}

# Example network
data "morpheus_network" "default" {
  name = var.network_name
}

# Example resource pool
data "morpheus_resource_pool" "default" {
  name     = var.resource_pool_name
  cloud_id = data.morpheus_cloud.target_cloud.id
}

# Example AWS instance resource
resource "morpheus_aws_instance" "example" {
  name               = var.instance_name
  description        = "Example Terraform managed instance"
  cloud_id           = data.morpheus_cloud.target_cloud.id
  group_id           = data.morpheus_group.default_group.id
  instance_type_id   = data.morpheus_instance_type.ubuntu.id
  instance_layout_id = data.morpheus_instance_layout.ubuntu_layout.id
  plan_id            = data.morpheus_plan.small.id
  environment        = "dev"
  resource_pool_id   = data.morpheus_resource_pool.default.id
  
  labels = ["terraform", "demo", "aws"]
  
  interfaces {
    network_id = data.morpheus_network.default.id
  }
  
  tags = {
    Name        = var.instance_name
    Environment = "development"
    ManagedBy   = "terraform"
    Project     = var.project_name
  }
  
  evar {
    name   = "APPLICATION_ENV"
    value  = "development"
    export = true
    masked = false
  }
  
  evar {
    name   = "API_KEY"
    value  = var.api_key
    export = false
    masked = true
  }
  
  custom_options = {
    backup_enabled = "true"
    monitoring     = "enabled"
  }
}

# Example user resource
resource "morpheus_user" "example_user" {
  username   = var.new_username
  first_name = var.first_name
  last_name  = var.last_name
  email      = var.email
  password   = var.user_password
  role_id    = var.role_id
  enabled    = true
}

# Example group resource
resource "morpheus_group" "example_group" {
  name        = var.new_group_name
  description = "Example group created by Terraform"
  location    = var.group_location
}

# Example environment resource
resource "morpheus_environment" "staging" {
  name        = "staging"
  description = "Staging environment for testing"
  code        = "staging"
  visibility  = "private"
}

# Example outputs
output "instance_id" {
  description = "The ID of the created instance"
  value       = morpheus_aws_instance.example.id
}

output "instance_ip" {
  description = "The IP address of the created instance"
  value       = morpheus_aws_instance.example.connection_info
  sensitive   = true
}

output "user_id" {
  description = "The ID of the created user"
  value       = morpheus_user.example_user.id
}

output "group_id" {
  description = "The ID of the created group"
  value       = morpheus_group.example_group.id
}

output "environment_id" {
  description = "The ID of the created environment"
  value       = morpheus_environment.staging.id
}