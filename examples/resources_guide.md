# Morpheus Terraform Provider Resources Guide

This guide provides an overview of all available resources in the Morpheus Terraform provider with examples.

## Cloud Management Resources

### Cloud Resources
- **morpheus_aws_cloud** - Amazon Web Services cloud integration
- **morpheus_azure_cloud** - Microsoft Azure cloud integration  
- **morpheus_vsphere_cloud** - VMware vSphere cloud integration
- **morpheus_standard_cloud** - Standard/Generic cloud integration

### Cloud Configuration
- **morpheus_vsphere_cloud_datastore_configuration** - Configure vSphere datastores

## Instance and Compute Resources

### Instance Resources
- **morpheus_aws_instance** - AWS EC2 instances
- **morpheus_vsphere_instance** - vSphere virtual machines
- **morpheus_mvm_instance** - Morpheus Virtual Machine instances

### Instance Management
- **morpheus_instance_type** - Custom instance types
- **morpheus_instance_layout** - Instance layouts and configurations
- **morpheus_node_type** - Node type definitions
- **morpheus_cluster_layout** - Cluster layout configurations

### Service Plans and Pricing
- **morpheus_service_plan** - Service plans for instances
- **morpheus_price** - Individual price definitions
- **morpheus_price_set** - Price sets for services

## User and Group Management

### User Resources
- **morpheus_user** - User accounts
- **morpheus_user_role** - User roles and permissions
- **morpheus_user_group** - User groups

### Group and Organization
- **morpheus_group** - Groups for resource organization
- **morpheus_tenant** - Tenant management
- **morpheus_tenant_role** - Tenant-specific roles

## Networking Resources

### Network Management
- **morpheus_network_domain** - DNS domains
- **morpheus_ipv4_ip_pool** - IPv4 IP address pools

### Resource Organization
- **morpheus_resource_pool_group** - Resource pool groupings

## Policy Resources

### Naming and Governance Policies
- **morpheus_hostname_policy** - Hostname naming conventions
- **morpheus_instance_name_policy** - Instance naming policies
- **morpheus_cluster_resource_name_policy** - Cluster resource naming

### Resource Limit Policies
- **morpheus_max_containers_policy** - Maximum containers per instance
- **morpheus_max_cores_policy** - Maximum CPU cores
- **morpheus_max_hosts_policy** - Maximum hosts
- **morpheus_max_memory_policy** - Maximum memory allocation
- **morpheus_max_storage_policy** - Maximum storage allocation
- **morpheus_max_vms_policy** - Maximum virtual machines

### Network and Security Policies
- **morpheus_network_quota_policy** - Network resource quotas
- **morpheus_router_quota_policy** - Router resource quotas
- **morpheus_cypher_access_policy** - Cypher secret access control
- **morpheus_tag_policy** - Resource tagging policies

### Operational Policies
- **morpheus_backup_creation_policy** - Automated backup policies
- **morpheus_delayed_delete_policy** - Delayed resource deletion
- **morpheus_power_schedule_policy** - Power management schedules
- **morpheus_workflow_policy** - Workflow execution policies
- **morpheus_motd_policy** - Message of the day policies

### Approval Policies
- **morpheus_provision_approval_policy** - Provision approval workflows
- **morpheus_delete_approval_policy** - Deletion approval workflows

### Budget and Cost Policies
- **morpheus_budget_policy** - Budget limits and controls
- **morpheus_user_creation_policy** - User creation policies
- **morpheus_user_group_creation_policy** - User group creation policies

## Automation Resources

### Task Resources
- **morpheus_shell_script_task** - Shell script execution
- **morpheus_ansible_playbook_task** - Ansible playbook execution
- **morpheus_ansible_tower_task** - Ansible Tower job execution
- **morpheus_chef_bootstrap_task** - Chef bootstrap tasks
- **morpheus_email_task** - Email notification tasks
- **morpheus_groovy_script_task** - Groovy script execution
- **morpheus_javascript_task** - JavaScript execution
- **morpheus_library_script_task** - Library script tasks
- **morpheus_library_template_task** - Library template tasks
- **morpheus_nested_workflow_task** - Nested workflow execution
- **morpheus_powershell_script_task** - PowerShell script execution
- **morpheus_python_script_task** - Python script execution
- **morpheus_restart_task** - Instance restart tasks
- **morpheus_ruby_script_task** - Ruby script execution
- **morpheus_vro_task** - vRealize Orchestrator tasks
- **morpheus_write_attributes_task** - Attribute writing tasks

### Workflow Resources
- **morpheus_operational_workflow** - Operational workflows
- **morpheus_provisioning_workflow** - Provisioning workflows

### Job Management
- **morpheus_task_job** - Scheduled task execution
- **morpheus_workflow_job** - Scheduled workflow execution

## Integration Resources

### Version Control
- **morpheus_git_integration** - Git repository integration

### Configuration Management
- **morpheus_ansible_integration** - Ansible integration
- **morpheus_ansible_tower_integration** - Ansible Tower integration
- **morpheus_chef_integration** - Chef integration
- **morpheus_puppet_integration** - Puppet integration

### Service Management
- **morpheus_servicenow_integration** - ServiceNow integration
- **morpheus_vro_integration** - vRealize Orchestrator integration

### Container Registries
- **morpheus_docker_registry_integration** - Docker registry integration

## Application and Blueprint Resources

### Application Blueprints
- **morpheus_terraform_app_blueprint** - Terraform-based applications
- **morpheus_cloud_formation_app_blueprint** - CloudFormation applications
- **morpheus_arm_app_blueprint** - Azure Resource Manager applications
- **morpheus_kubernetes_app_blueprint** - Kubernetes applications
- **morpheus_helm_app_blueprint** - Helm chart applications

### Spec Templates
- **morpheus_terraform_spec_template** - Terraform specifications
- **morpheus_cloud_formation_spec_template** - CloudFormation specifications
- **morpheus_arm_spec_template** - ARM template specifications
- **morpheus_kubernetes_spec_template** - Kubernetes specifications
- **morpheus_helm_spec_template** - Helm specifications

### Templates and Scripts
- **morpheus_script_template** - Reusable script templates
- **morpheus_file_template** - File templates
- **morpheus_boot_script** - Boot scripts for instances
- **morpheus_preseed_script** - Preseed scripts for provisioning

## Catalog and Provisioning Resources

### Catalog Items
- **morpheus_instance_catalog_item** - Instance catalog items
- **morpheus_app_blueprint_catalog_item** - Blueprint catalog items
- **morpheus_workflow_catalog_item** - Workflow catalog items

### Forms and Options
- **morpheus_form** - Custom forms
- **morpheus_checkbox_option_type** - Checkbox option types
- **morpheus_hidden_option_type** - Hidden option types
- **morpheus_number_option_type** - Number input option types
- **morpheus_password_option_type** - Password input option types
- **morpheus_radio_list_option_type** - Radio button option types
- **morpheus_select_list_option_type** - Select dropdown option types
- **morpheus_text_option_type** - Text input option types
- **morpheus_textarea_option_type** - Textarea option types
- **morpheus_typeahead_option_type** - Typeahead option types

### Option Lists
- **morpheus_manual_option_list** - Manually defined option lists
- **morpheus_api_option_list** - API-sourced option lists
- **morpheus_rest_option_list** - REST API option lists

## Security Resources

### Identity Sources
- **morpheus_active_directory_identity_source** - Active Directory integration
- **morpheus_saml_identity_source** - SAML identity provider integration

### Security Management
- **morpheus_security_package** - Security package definitions
- **morpheus_credential** - Credential management
- **morpheus_key_pair** - SSH key pair management
- **morpheus_cypher_secret** - Secret management with Cypher
- **morpheus_cypher_tfvars** - Terraform variables from Cypher

## Infrastructure Management

### Cluster Management
- **morpheus_cluster_package** - Cluster software packages
- **morpheus_vsphere_mks_cluster** - vSphere MKS clusters

### Monitoring and Scaling
- **morpheus_scale_threshold** - Auto-scaling thresholds

### Schedules
- **morpheus_execute_schedule** - Task execution schedules
- **morpheus_power_schedule** - Power management schedules

## Content Management

### Documentation
- **morpheus_wiki_page** - Wiki pages and documentation

### Environment Management
- **morpheus_environment** - Environment definitions

### Contact Management  
- **morpheus_contact** - Contact information

## Configuration Resources

### Settings
- **morpheus_appliance_setting** - Appliance-wide settings
- **morpheus_backup_setting** - Backup configuration settings
- **morpheus_guidance_setting** - Guidance and recommendation settings
- **morpheus_monitoring_setting** - Monitoring configuration
- **morpheus_provisioning_setting** - Provisioning configuration

### Licensing
- **morpheus_license** - License management

## Example Resource Usage

```hcl
# Create a user
resource "morpheus_user" "developer" {
  username   = "john.doe"
  first_name = "John"
  last_name  = "Doe"
  email      = "john.doe@company.com"
  password   = var.user_password
  role_id    = data.morpheus_user_role.developer.id
  enabled    = true
}

# Create a group
resource "morpheus_group" "development" {
  name        = "Development Team"
  description = "Development environment"
  location    = "us-east-1"
}

# Create an AWS instance
resource "morpheus_aws_instance" "web_server" {
  name               = "web-server"
  description        = "Web server instance"
  cloud_id           = data.morpheus_cloud.aws.id
  group_id           = morpheus_group.development.id
  instance_type_id   = data.morpheus_instance_type.ubuntu.id
  instance_layout_id = data.morpheus_instance_layout.ubuntu.id
  plan_id            = data.morpheus_plan.small.id
  environment        = "development"
  
  labels = ["web", "development"]
  
  interfaces {
    network_id = data.morpheus_network.default.id
  }
  
  tags = {
    Environment = "development"
    Role        = "web-server"
  }
}

# Create a backup policy
resource "morpheus_backup_creation_policy" "daily_backup" {
  name            = "Daily Backup"
  description     = "Daily backup for all instances"
  enabled         = true
  enforcement_type = "fixed"
  
  backup_type     = "morpheus"
  create_backup   = true
  backup_day      = 1
  backup_time     = "02:00"
  retention_count = 7
  
  accounts = [1]
  groups   = [morpheus_group.development.id]
}

# Create a hostname policy
resource "morpheus_hostname_policy" "naming" {
  name             = "Standard Naming"
  description      = "Standard hostname conventions"
  enabled          = true
  enforcement_type = "fixed"
  
  naming_pattern = "{{group.code}}-{{instance.type}}-{{sequence+100}}"
  
  accounts = [1]
  groups   = [morpheus_group.development.id]
}

# Create a shell script task
resource "morpheus_shell_script_task" "setup_server" {
  name           = "Server Setup"
  description    = "Initial server configuration"
  script_content = file("${path.module}/scripts/server_setup.sh")
  sudo           = true
  retryable      = true
  retry_count    = 3
}

# Create a workflow
resource "morpheus_operational_workflow" "deployment" {
  name        = "Application Deployment"
  description = "Deploy application to servers"
  
  tasks = [
    {
      task_id    = morpheus_shell_script_task.setup_server.id
      task_phase = "provision"
    }
  ]
}
```

This guide covers the major resource types available in the Morpheus Terraform provider. Each resource has specific configuration options and attributes that can be found in the provider documentation.