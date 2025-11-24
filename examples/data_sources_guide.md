# Data Sources Available in Morpheus Terraform Provider

This document provides an overview of all available data sources in the Morpheus Terraform provider.

## Cloud and Infrastructure Data Sources

### Cloud Management
- `morpheus_cloud` - Retrieve information about a specific cloud
- `morpheus_clouds` - List all available clouds
- `morpheus_cloud_type` - Get cloud type information
- `morpheus_cloud_datastore` - Get cloud datastore information
- `morpheus_cloud_folder` - Get cloud folder information

### Resource Management
- `morpheus_resource_pool` - Get resource pool information
- `morpheus_storage_bucket` - Get storage bucket details
- `morpheus_storage_volume` - Get storage volume information
- `morpheus_storage_volume_type` - Get storage volume type details

### Networking
- `morpheus_network` - Retrieve network information
- `morpheus_networks` - List all networks
- `morpheus_network_group` - Get network group details
- `morpheus_network_subnet` - Get subnet information

## Instance and Compute Data Sources

### Instance Types and Layouts
- `morpheus_instance_type` - Get instance type information
- `morpheus_instance_layout` - Get instance layout details
- `morpheus_node_type` - Get node type information
- `morpheus_provision_type` - Get provision type details

### Service Plans
- `morpheus_plan` - Get service plan information
- `morpheus_price` - Get pricing information
- `morpheus_price_set` - Get price set details

## User and Group Management Data Sources

### Users and Groups
- `morpheus_user_group` - Get user group information
- `morpheus_user_groups` - List all user groups
- `morpheus_group` - Get group information
- `morpheus_groups` - List all groups
- `morpheus_tenant` - Get tenant information
- `morpheus_tenants` - List all tenants
- `morpheus_tenant_role` - Get tenant role details

### Permissions
- `morpheus_permission_set` - Get permission set information

## Automation and Integration Data Sources

### Task Management
- `morpheus_task` - Get task information
- `morpheus_tasks` - List all tasks
- `morpheus_job` - Get job information

### Integrations
- `morpheus_integration` - Get integration information
- `morpheus_git_integration` - Get Git integration details
- `morpheus_ansible_tower_integration` - Get Ansible Tower integration
- `morpheus_ansible_tower_inventory` - Get Ansible Tower inventory
- `morpheus_ansible_tower_job_template` - Get Ansible Tower job templates
- `morpheus_chef_server` - Get Chef server information
- `morpheus_servicenow_workflow` - Get ServiceNow workflow details

### Scripts and Templates
- `morpheus_script_template` - Get script template information
- `morpheus_file_template` - Get file template details
- `morpheus_spec_template` - Get spec template information

## Security and Policy Data Sources

### Security
- `morpheus_security_package` - Get security package information
- `morpheus_credential` - Get credential information
- `morpheus_key_pair` - Get key pair details
- `morpheus_cypher_secret` - Get Cypher secret information

### Policies
- `morpheus_policy` - Get policy information
- `morpheus_policies` - List all policies

## Configuration and Options Data Sources

### Option Types and Lists
- `morpheus_option_type` - Get option type information
- `morpheus_option_list` - Get option list details

### Environments
- `morpheus_environment` - Get environment information
- `morpheus_environments` - List all environments

### Domains and Contacts
- `morpheus_domain` - Get domain information
- `morpheus_contact` - Get contact information

### Schedules
- `morpheus_execute_schedule` - Get execution schedule information
- `morpheus_power_schedule` - Get power schedule details

### Blueprints and Catalogs
- `morpheus_blueprint` - Get blueprint information
- `morpheus_catalog_item_type` - Get catalog item type details

### Budgets
- `morpheus_budget` - Get budget information

### Cluster Management
- `morpheus_cluster_type` - Get cluster type information

## Example Usage

```hcl
# Get cloud information
data "morpheus_cloud" "aws_cloud" {
  name = "AWS Production"
}

# Get group information
data "morpheus_group" "dev_group" {
  name = "Development"
}

# Get instance type
data "morpheus_instance_type" "ubuntu" {
  name = "Ubuntu"
}

# Get instance layout
data "morpheus_instance_layout" "ubuntu_layout" {
  name    = "Amazon VM"
  version = "22.04"
}

# Get service plan
data "morpheus_plan" "small" {
  name           = "T3 Small - 2 Core, 2GB Memory"
  provision_type = "Amazon EC2"
}

# Get network
data "morpheus_network" "default" {
  name = "Default Network"
}

# Get resource pool
data "morpheus_resource_pool" "aws_pool" {
  name     = "AWS-VPC"
  cloud_id = data.morpheus_cloud.aws_cloud.id
}

# Use data sources in resources
resource "morpheus_aws_instance" "example" {
  name               = "example-instance"
  cloud_id           = data.morpheus_cloud.aws_cloud.id
  group_id           = data.morpheus_group.dev_group.id
  instance_type_id   = data.morpheus_instance_type.ubuntu.id
  instance_layout_id = data.morpheus_instance_layout.ubuntu_layout.id
  plan_id            = data.morpheus_plan.small.id
  resource_pool_id   = data.morpheus_resource_pool.aws_pool.id
  
  interfaces {
    network_id = data.morpheus_network.default.id
  }
}
```

## Common Patterns

### Filter by Name
Most data sources support filtering by name:
```hcl
data "morpheus_cloud" "my_cloud" {
  name = "Production AWS"
}
```

### Filter by ID
You can also filter by ID where supported:
```hcl
data "morpheus_group" "my_group" {
  id = 123
}
```

### Filter by Cloud
Some data sources can be filtered by cloud:
```hcl
data "morpheus_resource_pool" "pool" {
  name     = "My Pool"
  cloud_id = data.morpheus_cloud.aws.id
}
```

### List Multiple Items
Some data sources return lists:
```hcl
data "morpheus_clouds" "all" {}

output "cloud_names" {
  value = [for cloud in data.morpheus_clouds.all.clouds : cloud.name]
}
```