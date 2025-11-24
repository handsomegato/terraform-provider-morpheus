# Windows Server 2025 Option Types for Hybrid Cloud

terraform {
  required_providers {
    morpheus = {
      source  = "gomorpheus/morpheus"
      version = "0.14.0"
    }
  }
}

###########################################
# DOMAIN CONFIGURATION OPTION TYPES
###########################################

# Domain Name Option Type
resource "morpheus_text_option_type" "domain_name" {
  name               = "Domain Name"
  description        = "Active Directory domain name to join"
  field_name         = "domainName"
  field_label        = "AD Domain"
  placeholder_text   = "company.local"
  default_value      = var.ad_domain
  required           = true
  export_meta        = true
}

# Domain Username Option Type
resource "morpheus_text_option_type" "domain_username" {
  name               = "Domain Username"
  description        = "Domain administrator username for joining"
  field_name         = "domainUsername"
  field_label        = "Domain Admin User"
  placeholder_text   = "Administrator@company.local"
  required           = true
  export_meta        = true
}

# Domain Password Option Type
resource "morpheus_password_option_type" "domain_password" {
  name               = "Domain Password"
  description        = "Domain administrator password"
  field_name         = "domainPassword"
  field_label        = "Domain Admin Password"
  required           = true
  export_meta        = false
}

# Organizational Unit Path
resource "morpheus_text_option_type" "ou_path" {
  name               = "Organizational Unit Path"
  description        = "OU path for computer account placement"
  field_name         = "ouPath"
  field_label        = "OU Path"
  placeholder_text   = "OU=Servers,DC=company,DC=local"
  default_value      = var.ad_computer_ou
  required           = false
  export_meta        = true
}

###########################################
# WINDOWS CONFIGURATION OPTION TYPES
###########################################

# Windows Administrator Password
resource "morpheus_password_option_type" "windows_admin_password" {
  name               = "Windows Administrator Password"
  description        = "Local administrator password for Windows"
  field_name         = "windowsAdminPassword"
  field_label        = "Windows Admin Password"
  required           = true
  export_meta        = false
}

# Windows Edition Selection
resource "morpheus_select_list_option_type" "windows_edition" {
  name               = "Windows Edition"
  description        = "Windows Server edition selection"
  field_name         = "windowsEdition"
  field_label        = "Windows Edition"
  required           = true
  
  option_list_id = morpheus_manual_option_list.windows_editions.id
}

# Windows License Type
resource "morpheus_select_list_option_type" "windows_license_type" {
  name               = "Windows License Type"
  description        = "Windows licensing model"
  field_name         = "windowsLicenseType"
  field_label        = "License Type"
  default_value      = var.windows_license_type
  required           = true
  
  option_list_id = morpheus_manual_option_list.license_types.id
}

###########################################
# SERVER ROLE OPTION TYPES
###########################################

# Server Role Selection
resource "morpheus_select_list_option_type" "server_role" {
  name               = "Server Role"
  description        = "Primary server role assignment"
  field_name         = "serverRole"
  field_label        = "Server Role"
  required           = true
  
  option_list_id = morpheus_manual_option_list.server_roles.id
}

# Domain Join Option
resource "morpheus_checkbox_option_type" "domain_join_option" {
  name               = "Domain Join"
  description        = "Join server to Active Directory domain"
  field_name         = "domainJoin"
  field_label        = "Join to Domain"
  default_value      = "true"
  required           = false
  export_meta        = true
}

# Install IIS Option
resource "morpheus_checkbox_option_type" "install_iis" {
  name               = "Install IIS"
  description        = "Install Internet Information Services"
  field_name         = "installIIS"
  field_label        = "Install IIS Web Server"
  default_value      = "false"
  required           = false
  export_meta        = true
}

# Configure File Server Option
resource "morpheus_checkbox_option_type" "configure_file_server" {
  name               = "Configure File Server"
  description        = "Configure server as file server with shares"
  field_name         = "configureFileServer"
  field_label        = "Configure as File Server"
  default_value      = "false"
  required           = false
  export_meta        = true
}

# Enable BitLocker Option
resource "morpheus_checkbox_option_type" "enable_bitlocker" {
  name               = "Enable BitLocker"
  description        = "Enable BitLocker drive encryption"
  field_name         = "enableBitLocker"
  field_label        = "Enable BitLocker Encryption"
  default_value      = var.enable_bitlocker ? "true" : "false"
  required           = false
  export_meta        = true
}

###########################################
# NETWORK CONFIGURATION OPTION TYPES
###########################################

# Static IP Option
resource "morpheus_text_option_type" "static_ip" {
  name               = "Static IP Address"
  description        = "Static IP address for the server"
  field_name         = "staticIP"
  field_label        = "Static IP"
  placeholder_text   = "10.0.100.10"
  required           = false
  export_meta        = true
}

# DNS Servers Option
resource "morpheus_text_option_type" "dns_servers" {
  name               = "DNS Servers"
  description        = "DNS server addresses (comma-separated)"
  field_name         = "dnsServers"
  field_label        = "DNS Servers"
  placeholder_text   = "10.0.100.10,10.0.100.11"
  default_value      = var.dc_ip_address
  required           = false
  export_meta        = true
}

# Gateway Option
resource "morpheus_text_option_type" "gateway" {
  name               = "Default Gateway"
  description        = "Default gateway IP address"
  field_name         = "gateway"
  field_label        = "Gateway"
  placeholder_text   = "10.0.100.1"
  required           = false
  export_meta        = true
}

###########################################
# STORAGE CONFIGURATION OPTION TYPES
###########################################

# Additional Storage Size
resource "morpheus_number_option_type" "additional_storage" {
  name               = "Additional Storage (GB)"
  description        = "Additional storage in GB"
  field_name         = "additionalStorage"
  field_label        = "Additional Storage"
  placeholder_text   = "100"
  min_value          = 0
  max_value          = 2048
  required           = false
  export_meta        = true
}

# Storage Type Selection
resource "morpheus_select_list_option_type" "storage_type" {
  name               = "Storage Type"
  description        = "Storage provisioning type"
  field_name         = "storageType"
  field_label        = "Storage Type"
  default_value      = "thick"
  required           = true
  
  option_list_id = morpheus_manual_option_list.storage_types.id
}

###########################################
# BACKUP CONFIGURATION OPTION TYPES
###########################################

# Backup Schedule Selection
resource "morpheus_select_list_option_type" "backup_schedule" {
  name               = "Backup Schedule"
  description        = "Backup schedule frequency"
  field_name         = "backupSchedule"
  field_label        = "Backup Schedule"
  default_value      = "daily"
  required           = true
  
  option_list_id = morpheus_manual_option_list.backup_schedules.id
}

# Backup Retention Days
resource "morpheus_number_option_type" "backup_retention" {
  name               = "Backup Retention (Days)"
  description        = "Number of days to retain backups"
  field_name         = "backupRetention"
  field_label        = "Backup Retention"
  default_value      = var.backup_retention_days
  min_value          = 1
  max_value          = 365
  required           = true
  export_meta        = true
}

###########################################
# OPTION LISTS
###########################################

# Windows Editions Option List
resource "morpheus_manual_option_list" "windows_editions" {
  name        = "Windows Server Editions"
  description = "Available Windows Server editions"
  
  list_items = [
    {
      name  = "Standard"
      value = "standard"
    },
    {
      name  = "Datacenter"
      value = "datacenter"
    },
    {
      name  = "Essentials"
      value = "essentials"
    }
  ]
}

# License Types Option List
resource "morpheus_manual_option_list" "license_types" {
  name        = "Windows License Types"
  description = "Windows licensing models"
  
  list_items = [
    {
      name  = "Azure Hybrid Benefit (AHUB)"
      value = "AHUB"
    },
    {
      name  = "Pay As You Go (PAYG)"
      value = "PAYG"
    },
    {
      name  = "Bring Your Own License (BYOL)"
      value = "BYOL"
    }
  ]
}

# Server Roles Option List
resource "morpheus_manual_option_list" "server_roles" {
  name        = "Windows Server Roles"
  description = "Available server roles and configurations"
  
  list_items = [
    {
      name  = "Domain Controller"
      value = "domain-controller"
    },
    {
      name  = "File Server"
      value = "file-server"
    },
    {
      name  = "Web Server (IIS)"
      value = "web-server"
    },
    {
      name  = "Database Server"
      value = "database-server"
    },
    {
      name  = "Application Server"
      value = "application-server"
    },
    {
      name  = "Terminal Server"
      value = "terminal-server"
    },
    {
      name  = "Generic Server"
      value = "generic-server"
    }
  ]
}

# Storage Types Option List
resource "morpheus_manual_option_list" "storage_types" {
  name        = "Storage Types"
  description = "Available storage provisioning types"
  
  list_items = [
    {
      name  = "Thin Provisioned"
      value = "thin"
    },
    {
      name  = "Thick Provisioned"
      value = "thick"
    },
    {
      name  = "Eager Zeroed Thick"
      value = "eager_zeroed_thick"
    }
  ]
}

# Backup Schedules Option List
resource "morpheus_manual_option_list" "backup_schedules" {
  name        = "Backup Schedules"
  description = "Available backup schedule options"
  
  list_items = [
    {
      name  = "Daily at 2 AM"
      value = "daily"
    },
    {
      name  = "Weekly (Sunday)"
      value = "weekly"
    },
    {
      name  = "Monthly (1st)"
      value = "monthly"
    },
    {
      name  = "Custom"
      value = "custom"
    }
  ]
}

###########################################
# ENVIRONMENT SPECIFIC OPTION TYPES
###########################################

# Environment Selection
resource "morpheus_select_list_option_type" "environment_type" {
  name               = "Environment Type"
  description        = "Target environment for deployment"
  field_name         = "environmentType"
  field_label        = "Environment"
  default_value      = var.environment
  required           = true
  
  option_list_id = morpheus_manual_option_list.environments.id
}

# Environments Option List
resource "morpheus_manual_option_list" "environments" {
  name        = "Deployment Environments"
  description = "Available deployment environments"
  
  list_items = [
    {
      name  = "Development"
      value = "dev"
    },
    {
      name  = "Staging"
      value = "staging"
    },
    {
      name  = "Production"
      value = "prod"
    },
    {
      name  = "Disaster Recovery"
      value = "dr"
    }
  ]
}

# Cost Center Option
resource "morpheus_text_option_type" "cost_center" {
  name               = "Cost Center"
  description        = "Cost center for billing and tracking"
  field_name         = "costCenter"
  field_label        = "Cost Center"
  default_value      = var.cost_center
  required           = true
  export_meta        = true
}

# Owner Information Option
resource "morpheus_text_option_type" "owner_email" {
  name               = "Owner Email"
  description        = "Email address of the resource owner"
  field_name         = "ownerEmail"
  field_label        = "Owner Email"
  placeholder_text   = "admin@company.com"
  default_value      = var.owner
  required           = true
  export_meta        = true
}

###########################################
# OUTPUTS
###########################################

output "option_types_created" {
  description = "List of created option types"
  value = {
    domain_configuration = [
      morpheus_text_option_type.domain_name.name,
      morpheus_text_option_type.domain_username.name,
      morpheus_password_option_type.domain_password.name,
      morpheus_text_option_type.ou_path.name
    ]
    windows_configuration = [
      morpheus_password_option_type.windows_admin_password.name,
      morpheus_select_list_option_type.windows_edition.name,
      morpheus_select_list_option_type.windows_license_type.name
    ]
    server_roles = [
      morpheus_select_list_option_type.server_role.name,
      morpheus_checkbox_option_type.domain_join_option.name,
      morpheus_checkbox_option_type.install_iis.name,
      morpheus_checkbox_option_type.configure_file_server.name
    ]
    network_storage = [
      morpheus_text_option_type.static_ip.name,
      morpheus_text_option_type.dns_servers.name,
      morpheus_number_option_type.additional_storage.name,
      morpheus_select_list_option_type.storage_type.name
    ]
  }
}

output "option_lists_created" {
  description = "List of created option lists"
  value = [
    morpheus_manual_option_list.windows_editions.name,
    morpheus_manual_option_list.license_types.name,
    morpheus_manual_option_list.server_roles.name,
    morpheus_manual_option_list.storage_types.name,
    morpheus_manual_option_list.backup_schedules.name,
    morpheus_manual_option_list.environments.name
  ]
}