# Morpheus Terraform Provider Examples

This directory contains comprehensive examples for using the Morpheus Terraform provider.

## 📁 Directory Structure

```
examples/
├── complete_configuration/     # Complete Terraform configuration with provider setup
├── provider_configurations/   # Various provider authentication methods
├── comprehensive_resources/    # Extensive resource examples
├── data_sources_guide.md      # Guide to all available data sources
└── resources_guide.md         # Guide to all available resources
```

## 🚀 Quick Start

1. **Provider Configuration**: Start with the provider configuration examples
2. **Complete Configuration**: Use the complete configuration as a template
3. **Resource Examples**: Explore specific resource examples
4. **Data Sources**: Reference the data sources guide for available data

## 📋 Prerequisites

- Terraform >= 1.0
- Access to a Morpheus platform instance
- Valid credentials (username/password or access token)

## 🔧 Provider Setup

### Basic Configuration

```hcl
terraform {
  required_providers {
    morpheus = {
      source  = "gomorpheus/morpheus"
      version = "0.14.0"
    }
  }
}

provider "morpheus" {
  url      = "https://your-morpheus.com"
  username = "your-username"
  password = "your-password"
  secure   = true
}
```

### Environment Variables

You can also configure the provider using environment variables:

```bash
export MORPHEUS_URL="https://your-morpheus.com"
export MORPHEUS_USERNAME="your-username"
export MORPHEUS_PASSWORD="your-password"
export MORPHEUS_SECURE="true"
```

## 📖 Example Categories

### 1. Complete Configuration (`complete_configuration/`)
- Full working example with provider setup
- Multiple resource types
- Variable definitions
- Output values

### 2. Provider Configurations (`provider_configurations/`)
- Username/password authentication
- Access token authentication
- Multi-tenant configuration
- Environment variable usage

### 3. Comprehensive Resources (`comprehensive_resources/`)
- Cloud management (AWS, vSphere, Azure)
- Instance provisioning
- User and group management
- Policy configuration
- Automation workflows
- Security and networking

## 🎯 Common Use Cases

### Instance Provisioning
```hcl
resource "morpheus_aws_instance" "web_server" {
  name               = "web-server"
  cloud_id           = data.morpheus_cloud.aws.id
  group_id           = data.morpheus_group.default.id
  instance_type_id   = data.morpheus_instance_type.ubuntu.id
  instance_layout_id = data.morpheus_instance_layout.ubuntu.id
  plan_id            = data.morpheus_plan.small.id
}
```

### User Management
```hcl
resource "morpheus_user" "developer" {
  username   = "john.doe"
  first_name = "John"
  last_name  = "Doe"
  email      = "john.doe@company.com"
  password   = var.password
  role_id    = data.morpheus_user_role.developer.id
}
```

### Policy Configuration
```hcl
resource "morpheus_hostname_policy" "naming" {
  name           = "Standard Naming"
  enabled        = true
  naming_pattern = "{{group.code}}-{{instance.type}}-{{sequence}}"
  accounts       = [1]
}
```

## 🔍 Data Sources

The provider includes extensive data sources for referencing existing resources:

- **Clouds**: `morpheus_cloud`, `morpheus_clouds`
- **Groups**: `morpheus_group`, `morpheus_groups`
- **Networks**: `morpheus_network`, `morpheus_networks`
- **Instance Types**: `morpheus_instance_type`, `morpheus_instance_layout`
- **Plans**: `morpheus_plan`
- **Users**: `morpheus_user_group`, `morpheus_user_groups`

## 🛠️ Best Practices

### 1. Use Data Sources
Reference existing resources using data sources rather than hardcoding IDs:

```hcl
data "morpheus_group" "default" {
  name = "Default"
}

resource "morpheus_aws_instance" "example" {
  group_id = data.morpheus_group.default.id
  # ...
}
```

### 2. Variable Management
Use variables for sensitive and environment-specific values:

```hcl
variable "morpheus_password" {
  description = "Morpheus password"
  type        = string
  sensitive   = true
}
```

### 3. Environment Separation
Use different configurations for different environments:

```hcl
variable "environment" {
  description = "Environment name"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
```

### 4. Resource Tagging
Use consistent tagging across resources:

```hcl
tags = {
  Environment = var.environment
  ManagedBy   = "terraform"
  Project     = var.project_name
}
```

## 📚 Additional Resources

- [Morpheus Documentation](https://docs.morpheusdata.com/)
- [Terraform Provider Registry](https://registry.terraform.io/providers/gomorpheus/morpheus)
- [Provider Source Code](https://github.com/gomorpheus/terraform-provider-morpheus)

## 🤝 Contributing

To contribute new examples:

1. Follow the existing directory structure
2. Include comprehensive variable definitions
3. Add appropriate documentation
4. Test configurations before submitting

## 📄 License

These examples are provided under the same license as the Morpheus Terraform provider.