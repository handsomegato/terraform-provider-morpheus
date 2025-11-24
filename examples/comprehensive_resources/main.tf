# Comprehensive examples of Morpheus resources

terraform {
  required_providers {
    morpheus = {
      source  = "gomorpheus/morpheus"
      version = "0.14.0"
    }
  }
}

provider "morpheus" {
  url      = var.morpheus_url
  username = var.morpheus_username
  password = var.morpheus_password
  secure   = true
}

###########################################
# CLOUD MANAGEMENT RESOURCES
###########################################

# AWS Cloud
resource "morpheus_aws_cloud" "example_aws" {
  name                = "terraform-aws-cloud"
  description         = "AWS cloud managed by Terraform"
  location            = "us-east-1"
  visibility          = "private"
  tenant_id           = 1
  enabled             = true
  automatically_power_on_vms = true
  
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1"
  
  endpoint          = "https://ec2.us-east-1.amazonaws.com"
  image_store_id    = 1
  backup_mode       = "internal"
  replication_mode  = "internal"
  security_mode     = "internal"
  certificate_provider = "internal"
}

# vSphere Cloud
resource "morpheus_vsphere_cloud" "example_vsphere" {
  name        = "terraform-vsphere-cloud"
  description = "vSphere cloud managed by Terraform"
  location    = "datacenter-1"
  visibility  = "private"
  tenant_id   = 1
  enabled     = true
  
  api_url     = "https://vcenter.example.com"
  username    = var.vsphere_username
  password    = var.vsphere_password
  datacenter  = "Datacenter1"
  cluster     = "Cluster1"
  
  resource_pool           = "Resources"
  rpc_mode               = "guestexec"
  hide_host_selection    = false
  import_existing        = true
  enable_hypervisor_console = true
}

###########################################
# INSTANCE MANAGEMENT RESOURCES
###########################################

# AWS Instance
resource "morpheus_aws_instance" "web_server" {
  name               = "web-server-tf"
  description        = "Web server managed by Terraform"
  cloud_id           = morpheus_aws_cloud.example_aws.id
  group_id           = data.morpheus_group.default.id
  instance_type_id   = data.morpheus_instance_type.ubuntu.id
  instance_layout_id = data.morpheus_instance_layout.ubuntu.id
  plan_id            = data.morpheus_plan.small.id
  environment        = "production"
  
  labels = ["web", "terraform", "production"]
  
  interfaces {
    network_id = data.morpheus_network.default.id
  }
  
  volumes {
    name         = "root"
    size         = 20
    datastore_id = 1
  }
  
  tags = {
    Name        = "web-server-tf"
    Environment = "production"
    Role        = "web-server"
    ManagedBy   = "terraform"
  }
  
  evar {
    name   = "ENVIRONMENT"
    value  = "production"
    export = true
    masked = false
  }
  
  evar {
    name   = "DATABASE_PASSWORD"
    value  = var.db_password
    export = false
    masked = true
  }
}

###########################################
# USER AND GROUP MANAGEMENT
###########################################

# User creation
resource "morpheus_user" "developer" {
  username     = "john.doe"
  first_name   = "John"
  last_name    = "Doe"
  email        = "john.doe@example.com"
  password     = var.user_password
  role_id      = data.morpheus_user_role.developer.id
  enabled      = true
  receive_notifications = true
  
  default_group_id = morpheus_group.development.id
  default_persona  = "standard"
}

# Group creation
resource "morpheus_group" "development" {
  name        = "Development Team"
  description = "Development team group"
  location    = "us-east-1"
  
  dns_integration_id = data.morpheus_dns_integration.route53.id
  service_registry_id = data.morpheus_service_registry.consul.id
  config_management_id = data.morpheus_config_management.ansible.id
}

# User Group
resource "morpheus_user_group" "developers" {
  name        = "Developers"
  description = "Developer user group"
  sudo_user   = true
  
  users = [
    morpheus_user.developer.id
  ]
}

###########################################
# POLICIES
###########################################

# Hostname Policy
resource "morpheus_hostname_policy" "naming_convention" {
  name            = "Standard Naming Convention"
  description     = "Enforces standard hostname conventions"
  enabled         = true
  enforcement_type = "fixed"
  
  naming_pattern = "{{group.code}}-{{instance.type}}-{{sequence+1000}}"
  
  accounts = [1]
  groups   = [morpheus_group.development.id]
}

# Backup Policy
resource "morpheus_backup_creation_policy" "daily_backup" {
  name            = "Daily Backup Policy"
  description     = "Daily backup for production instances"
  enabled         = true
  enforcement_type = "fixed"
  
  backup_type     = "morpheus"
  create_backup   = true
  backup_day      = 1  # Daily
  backup_time     = "02:00"
  retention_count = 7
  
  accounts = [1]
  groups   = [morpheus_group.development.id]
}

# Budget Policy
resource "morpheus_budget_policy" "team_budget" {
  name            = "Team Budget Policy"
  description     = "Monthly budget limit for development team"
  enabled         = true
  enforcement_type = "fixed"
  
  max_price       = 1000.00
  currency        = "USD"
  period          = "month"
  year            = 2025
  
  accounts = [1]
  groups   = [morpheus_group.development.id]
}

###########################################
# AUTOMATION RESOURCES
###########################################

# Script Template
resource "morpheus_script_template" "server_setup" {
  name        = "Server Setup Script"
  description = "Initial server configuration script"
  script_type = "bash"
  script_phase = "provision"
  
  script_content = <<-EOT
#!/bin/bash
# Initial server setup
apt-get update
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx

# Configure firewall
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw --force enable

echo "Server setup completed" > /var/log/morpheus-setup.log
EOT
}

# Task (using script template)
resource "morpheus_shell_script_task" "deploy_app" {
  name              = "Deploy Application"
  description       = "Deploys the application to target servers"
  labels            = ["deployment", "automation"]
  script_content    = file("${path.module}/scripts/deploy.sh")
  sudo              = true
  retryable         = true
  retry_count       = 3
  retry_delay_seconds = 30
  allow_custom_config = true
}

# Workflow
resource "morpheus_operational_workflow" "server_deployment" {
  name        = "Server Deployment Workflow"
  description = "Complete server deployment and configuration workflow"
  labels      = ["deployment", "servers"]
  
  option_types = [
    data.morpheus_option_type.target_group.id,
    data.morpheus_option_type.app_version.id
  ]
  
  tasks = [
    {
      task_id    = morpheus_shell_script_task.deploy_app.id
      task_phase = "provision"
    }
  ]
}

###########################################
# INTEGRATIONS
###########################################

# Git Integration
resource "morpheus_git_integration" "company_repo" {
  name             = "Company Repository"
  description      = "Main company Git repository"
  url              = "https://github.com/company/infrastructure"
  username         = var.git_username
  password         = var.git_token
  default_branch   = "main"
  enabled          = true
  enable_git_repository_scanning = true
}

# Ansible Integration
resource "morpheus_ansible_integration" "automation" {
  name        = "Ansible Automation"
  description = "Ansible automation platform integration"
  ansible_url = "https://ansible.example.com"
  username    = var.ansible_username
  password    = var.ansible_password
  enabled     = true
  
  default_branch      = "main"
  playbook_path      = "playbooks/"
  roles_path         = "roles/"
  group_variables_path = "group_vars/"
  host_variables_path  = "host_vars/"
}

###########################################
# STORAGE AND NETWORKING
###########################################

# Network Domain
resource "morpheus_network_domain" "company_domain" {
  name              = "company.local"
  description       = "Company internal domain"
  fqdn             = "company.local"
  join_domain_controller = false
  visibility       = "private"
  
  dc_server        = "dc1.company.local"
  username         = var.domain_username
  password         = var.domain_password
}

# Key Pair
resource "morpheus_key_pair" "deployment_key" {
  name           = "deployment-keypair"
  description    = "SSH key pair for deployments"
  public_key     = file("~/.ssh/id_rsa.pub")
  private_key    = file("~/.ssh/id_rsa")
  passphrase     = var.ssh_passphrase
}

###########################################
# DATA SOURCES FOR REFERENCE
###########################################

data "morpheus_group" "default" {
  name = "Default"
}

data "morpheus_instance_type" "ubuntu" {
  name = "Ubuntu"
}

data "morpheus_instance_layout" "ubuntu" {
  name    = "Amazon VM"
  version = "22.04"
}

data "morpheus_plan" "small" {
  name           = "T3 Small - 2 Core, 2GB Memory"
  provision_type = "Amazon EC2"
}

data "morpheus_network" "default" {
  name = "Default Network"
}

data "morpheus_user_role" "developer" {
  authority = "Developer"
}

data "morpheus_dns_integration" "route53" {
  name = "AWS Route 53"
}

data "morpheus_service_registry" "consul" {
  name = "Consul"
}

data "morpheus_config_management" "ansible" {
  name = "Ansible"
}

data "morpheus_option_type" "target_group" {
  name = "Target Group"
}

data "morpheus_option_type" "app_version" {
  name = "Application Version"
}