# Hybrid Cloud Windows Server 2025 Policies and Governance

terraform {
  required_providers {
    morpheus = {
      source  = "gomorpheus/morpheus"
      version = "0.14.0"
    }
  }
}

###########################################
# WINDOWS-SPECIFIC POLICIES
###########################################

# Windows Hostname Policy with AD-compatible naming
resource "morpheus_hostname_policy" "windows_naming_convention" {
  name            = "Windows Server Naming Convention"
  description     = "Standard naming for Windows servers in hybrid cloud"
  enabled         = true
  enforcement_type = "fixed"
  
  # Windows-compatible naming pattern (15 characters max for NetBIOS)
  naming_pattern = "{{group.code}}{{instance.type}}{{sequence+100 | substring(0,2)}}"
  
  accounts = [1]
  groups   = [
    data.morpheus_group.infrastructure.id,
    data.morpheus_group.file_services.id,
    data.morpheus_group.web_services.id
  ]
}

# Windows Server Backup Policy
resource "morpheus_backup_creation_policy" "windows_backup" {
  name            = "Windows Server Backup Policy"
  description     = "Daily backup policy for Windows servers"
  enabled         = true
  enforcement_type = "fixed"
  
  backup_type     = "morpheus"
  create_backup   = true
  backup_day      = 1  # Daily
  backup_time     = "02:00"
  retention_count = var.backup_retention_days
  
  # Apply to Windows instances
  accounts = [1]
  groups   = [
    data.morpheus_group.infrastructure.id,
    data.morpheus_group.file_services.id,
    data.morpheus_group.web_services.id
  ]
}

# Windows License Compliance Policy
resource "morpheus_tag_policy" "windows_licensing" {
  name            = "Windows Licensing Compliance"
  description     = "Enforce Windows licensing tags"
  enabled         = true
  enforcement_type = "fixed"
  
  key   = "WindowsLicense"
  value = var.windows_license_type
  
  accounts = [1]
  groups   = [
    data.morpheus_group.infrastructure.id,
    data.morpheus_group.file_services.id,
    data.morpheus_group.web_services.id
  ]
}

# Domain Join Policy
resource "morpheus_tag_policy" "domain_membership" {
  name            = "Domain Membership Policy"
  description     = "Ensure all Windows servers are domain-joined"
  enabled         = true
  enforcement_type = "fixed"
  
  key   = "DomainJoined"
  value = "true"
  
  accounts = [1]
  groups   = [
    data.morpheus_group.infrastructure.id,
    data.morpheus_group.file_services.id,
    data.morpheus_group.web_services.id
  ]
}

# Windows Update Policy
resource "morpheus_tag_policy" "windows_updates" {
  name            = "Windows Update Policy"
  description     = "Track Windows update status"
  enabled         = true
  enforcement_type = "fixed"
  
  key   = "UpdateManagement"
  value = "WSUS"
  
  accounts = [1]
  groups   = [
    data.morpheus_group.infrastructure.id,
    data.morpheus_group.file_services.id,
    data.morpheus_group.web_services.id
  ]
}

# Anti-virus Policy
resource "morpheus_tag_policy" "antivirus_protection" {
  name            = "Anti-virus Protection Policy"
  description     = "Ensure anti-virus protection is enabled"
  enabled         = true
  enforcement_type = "fixed"
  
  key   = "AntiVirus"
  value = "WindowsDefender"
  
  accounts = [1]
  groups   = [
    data.morpheus_group.infrastructure.id,
    data.morpheus_group.file_services.id,
    data.morpheus_group.web_services.id
  ]
}

# Resource Sizing Policies for Windows
resource "morpheus_max_memory_policy" "windows_memory_limit" {
  name            = "Windows Server Memory Limits"
  description     = "Memory limits for Windows servers"
  enabled         = true
  enforcement_type = "fixed"
  
  max_memory = 32768  # 32GB max per instance
  
  accounts = [1]
  groups   = [
    data.morpheus_group.infrastructure.id,
    data.morpheus_group.file_services.id,
    data.morpheus_group.web_services.id
  ]
}

resource "morpheus_max_cores_policy" "windows_cpu_limit" {
  name            = "Windows Server CPU Limits"
  description     = "CPU core limits for Windows servers"
  enabled         = true
  enforcement_type = "fixed"
  
  max_cores = 16  # 16 cores max per instance
  
  accounts = [1]
  groups   = [
    data.morpheus_group.infrastructure.id,
    data.morpheus_group.file_services.id,
    data.morpheus_group.web_services.id
  ]
}

resource "morpheus_max_storage_policy" "windows_storage_limit" {
  name            = "Windows Server Storage Limits"
  description     = "Storage limits for Windows servers"
  enabled         = true
  enforcement_type = "fixed"
  
  max_storage = 2048  # 2TB max per instance
  
  accounts = [1]
  groups   = [
    data.morpheus_group.infrastructure.id,
    data.morpheus_group.file_services.id,
    data.morpheus_group.web_services.id
  ]
}

# Budget Policy for Hybrid Infrastructure
resource "morpheus_budget_policy" "hybrid_infrastructure_budget" {
  name            = "Hybrid Infrastructure Budget"
  description     = "Monthly budget for hybrid Windows infrastructure"
  enabled         = true
  enforcement_type = "fixed"
  
  max_price = 10000.00  # $10K monthly budget
  currency  = "USD"
  period    = "month"
  year      = 2025
  
  accounts = [1]
  groups   = [
    data.morpheus_group.infrastructure.id,
    data.morpheus_group.file_services.id,
    data.morpheus_group.web_services.id
  ]
}

# Network Quota Policy
resource "morpheus_network_quota_policy" "hybrid_network_quota" {
  name            = "Hybrid Network Quota Policy"
  description     = "Network resource quotas for hybrid environment"
  enabled         = true
  enforcement_type = "fixed"
  
  max_networks = 10  # Maximum networks per group
  
  accounts = [1]
  groups   = [
    data.morpheus_group.infrastructure.id,
    data.morpheus_group.file_services.id,
    data.morpheus_group.web_services.id
  ]
}

# Approval Policies
resource "morpheus_provision_approval_policy" "windows_provision_approval" {
  name            = "Windows Server Provision Approval"
  description     = "Require approval for Windows server provisioning"
  enabled         = true
  enforcement_type = "fixed"
  
  accounts = [1]
  groups   = [
    data.morpheus_group.infrastructure.id,
    data.morpheus_group.file_services.id,
    data.morpheus_group.web_services.id
  ]
}

resource "morpheus_delete_approval_policy" "windows_delete_approval" {
  name            = "Windows Server Delete Approval"
  description     = "Require approval for Windows server deletion"
  enabled         = true
  enforcement_type = "fixed"
  
  accounts = [1]
  groups   = [
    data.morpheus_group.infrastructure.id,
    data.morpheus_group.file_services.id,
    data.morpheus_group.web_services.id
  ]
}

# Power Schedule for Non-Production
resource "morpheus_power_schedule_policy" "non_production_schedule" {
  name            = "Non-Production Power Schedule"
  description     = "Power schedule for development and testing environments"
  enabled         = true
  enforcement_type = "fixed"
  
  # Only apply to non-production groups
  accounts = [1]
  groups   = [data.morpheus_group.development.id]
}

# Message of the Day Policy
resource "morpheus_motd_policy" "windows_security_notice" {
  name            = "Windows Security Notice"
  description     = "Security notice for Windows servers"
  enabled         = true
  enforcement_type = "fixed"
  
  message = <<-EOT
******************************************************************************
                            AUTHORIZED ACCESS ONLY
******************************************************************************

This is a private computer system owned by [Company Name]. Unauthorized 
access is prohibited and violators will be prosecuted to the full extent 
of the law.

- All activities are monitored and logged
- Windows Server 2025 Datacenter Edition
- Domain: ${var.ad_domain}
- Contact IT Support: support@company.com

By continuing, you acknowledge and consent to monitoring.
******************************************************************************
EOT

  accounts = [1]
  groups   = [
    data.morpheus_group.infrastructure.id,
    data.morpheus_group.file_services.id,
    data.morpheus_group.web_services.id
  ]
}

# Cypher Access Policy for Secrets
resource "morpheus_cypher_access_policy" "windows_secrets_access" {
  name            = "Windows Secrets Access Policy"
  description     = "Control access to Windows-related secrets"
  enabled         = true
  enforcement_type = "fixed"
  
  # Restrict access to specific secret paths
  cypher_access = "read"
  
  accounts = [1]
  groups   = [
    data.morpheus_group.infrastructure.id,
    data.morpheus_group.file_services.id,
    data.morpheus_group.web_services.id
  ]
}

# User Creation Policy for AD Integration
resource "morpheus_user_creation_policy" "ad_user_creation" {
  name            = "Active Directory User Creation"
  description     = "Policy for creating users integrated with Active Directory"
  enabled         = true
  enforcement_type = "fixed"
  
  create_user_type = "local"  # Users managed through AD
  
  accounts = [1]
  groups   = [
    data.morpheus_group.infrastructure.id,
    data.morpheus_group.file_services.id,
    data.morpheus_group.web_services.id
  ]
}

# Workflow Policy for Windows Deployment
resource "morpheus_workflow_policy" "windows_deployment_workflow" {
  name            = "Windows Deployment Workflow"
  description     = "Standardize Windows server deployment process"
  enabled         = true
  enforcement_type = "fixed"
  
  workflow_id = data.morpheus_workflow.windows_deployment.id
  
  accounts = [1]
  groups   = [
    data.morpheus_group.infrastructure.id,
    data.morpheus_group.file_services.id,
    data.morpheus_group.web_services.id
  ]
}

###########################################
# DATA SOURCES
###########################################

data "morpheus_group" "infrastructure" {
  name = "Infrastructure"
}

data "morpheus_group" "file_services" {
  name = "File Services"
}

data "morpheus_group" "web_services" {
  name = "Web Services"
}

data "morpheus_group" "development" {
  name = "Development"
}

data "morpheus_workflow" "windows_deployment" {
  name = "Windows Server Deployment"
}

###########################################
# OUTPUTS
###########################################

output "applied_policies" {
  description = "List of applied policies"
  value = [
    morpheus_hostname_policy.windows_naming_convention.name,
    morpheus_backup_creation_policy.windows_backup.name,
    morpheus_tag_policy.windows_licensing.name,
    morpheus_tag_policy.domain_membership.name,
    morpheus_budget_policy.hybrid_infrastructure_budget.name
  ]
}

output "policy_enforcement" {
  description = "Policy enforcement summary"
  value = {
    naming_convention = morpheus_hostname_policy.windows_naming_convention.enforcement_type
    backup_policy     = morpheus_backup_creation_policy.windows_backup.enforcement_type
    budget_limit      = morpheus_budget_policy.hybrid_infrastructure_budget.max_price
    memory_limit_gb   = morpheus_max_memory_policy.windows_memory_limit.max_memory / 1024
    cpu_limit_cores   = morpheus_max_cores_policy.windows_cpu_limit.max_cores
    storage_limit_gb  = morpheus_max_storage_policy.windows_storage_limit.max_storage
  }
}