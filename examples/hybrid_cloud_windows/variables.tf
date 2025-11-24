# Morpheus Provider Configuration
variable "morpheus_url" {
  description = "Morpheus platform URL"
  type        = string
}

variable "morpheus_username" {
  description = "Morpheus username"
  type        = string
}

variable "morpheus_password" {
  description = "Morpheus password"
  type        = string
  sensitive   = true
}

variable "morpheus_secure" {
  description = "Enable SSL certificate verification"
  type        = bool
  default     = true
}

# Environment Configuration
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "prod"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

###########################################
# ACTIVE DIRECTORY CONFIGURATION
###########################################

variable "ad_domain" {
  description = "Active Directory domain name"
  type        = string
  default     = "company.local"
}

variable "ad_server" {
  description = "Active Directory server FQDN"
  type        = string
}

variable "ad_dc_server" {
  description = "Active Directory Domain Controller FQDN"
  type        = string
}

variable "ad_service_username" {
  description = "Service account username for AD operations"
  type        = string
}

variable "ad_service_password" {
  description = "Service account password for AD operations"
  type        = string
  sensitive   = true
}

variable "ad_admin_username" {
  description = "Domain administrator username"
  type        = string
  default     = "Administrator"
}

variable "ad_admin_password" {
  description = "Domain administrator password"
  type        = string
  sensitive   = true
}

variable "ad_search_base_dn" {
  description = "LDAP search base DN"
  type        = string
  default     = "DC=company,DC=local"
}

variable "ad_required_group_dn" {
  description = "Required group DN for user access"
  type        = string
  default     = "CN=Morpheus Users,OU=Groups,DC=company,DC=local"
}

variable "ad_computer_ou" {
  description = "Organizational Unit for computer accounts"
  type        = string
  default     = "OU=Servers,DC=company,DC=local"
}

variable "ad_safe_mode_password" {
  description = "Directory Services Restore Mode password"
  type        = string
  sensitive   = true
}

###########################################
# ON-PREMISES VSPHERE CONFIGURATION
###########################################

variable "onprem_location" {
  description = "On-premises datacenter location"
  type        = string
  default     = "Primary Datacenter"
}

variable "vsphere_url" {
  description = "vSphere vCenter URL"
  type        = string
}

variable "vsphere_username" {
  description = "vSphere username"
  type        = string
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}

variable "vsphere_datacenter" {
  description = "vSphere datacenter name"
  type        = string
  default     = "Datacenter1"
}

variable "vsphere_cluster" {
  description = "vSphere cluster name"
  type        = string
  default     = "Cluster1"
}

variable "vsphere_resource_pool" {
  description = "vSphere resource pool name"
  type        = string
  default     = "Resources"
}

###########################################
# AZURE HYBRID CONFIGURATION
###########################################

variable "azure_location" {
  description = "Azure region for hybrid workloads"
  type        = string
  default     = "East US"
}

variable "azure_client_id" {
  description = "Azure service principal client ID"
  type        = string
  sensitive   = true
}

variable "azure_client_secret" {
  description = "Azure service principal client secret"
  type        = string
  sensitive   = true
}

variable "azure_tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "azure_resource_group" {
  description = "Azure resource group for hybrid resources"
  type        = string
  default     = "morpheus-hybrid-rg"
}

variable "azure_key_pair" {
  description = "Azure SSH key pair for Linux instances"
  type        = string
  default     = "azure-keypair"
}

###########################################
# WINDOWS SERVER 2025 CONFIGURATION
###########################################

variable "windows_admin_password" {
  description = "Windows Administrator password"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.windows_admin_password) >= 12
    error_message = "Windows admin password must be at least 12 characters long."
  }
}

variable "dc_ip_address" {
  description = "Static IP address for domain controller"
  type        = string
  
  validation {
    condition     = can(cidrhost("${var.dc_ip_address}/32", 0))
    error_message = "Domain controller IP must be a valid IPv4 address."
  }
}

###########################################
# INSTANCE SIZING CONFIGURATION
###########################################

variable "dc_cpu_cores" {
  description = "CPU cores for domain controller"
  type        = number
  default     = 4
}

variable "dc_memory_gb" {
  description = "Memory in GB for domain controller"
  type        = number
  default     = 8
}

variable "dc_storage_gb" {
  description = "Storage in GB for domain controller"
  type        = number
  default     = 100
}

variable "fs_cpu_cores" {
  description = "CPU cores for file server"
  type        = number
  default     = 4
}

variable "fs_memory_gb" {
  description = "Memory in GB for file server"
  type        = number
  default     = 16
}

variable "fs_storage_gb" {
  description = "Storage in GB for file server"
  type        = number
  default     = 500
}

variable "web_cpu_cores" {
  description = "CPU cores for web server"
  type        = number
  default     = 4
}

variable "web_memory_gb" {
  description = "Memory in GB for web server"
  type        = number
  default     = 8
}

variable "web_storage_gb" {
  description = "Storage in GB for web server"
  type        = number
  default     = 200
}

###########################################
# NETWORK CONFIGURATION
###########################################

variable "infrastructure_vlan_id" {
  description = "VLAN ID for infrastructure network"
  type        = number
  default     = 100
}

variable "dmz_vlan_id" {
  description = "VLAN ID for DMZ network"
  type        = number
  default     = 200
}

variable "infrastructure_subnet" {
  description = "Infrastructure subnet CIDR"
  type        = string
  default     = "10.0.100.0/24"
}

variable "dmz_subnet" {
  description = "DMZ subnet CIDR"
  type        = string
  default     = "10.0.200.0/24"
}

###########################################
# BACKUP AND MONITORING
###########################################

variable "backup_enabled" {
  description = "Enable backup for instances"
  type        = bool
  default     = true
}

variable "backup_retention_days" {
  description = "Backup retention period in days"
  type        = number
  default     = 30
}

variable "monitoring_enabled" {
  description = "Enable monitoring for instances"
  type        = bool
  default     = true
}

###########################################
# SECURITY CONFIGURATION
###########################################

variable "enable_windows_defender" {
  description = "Enable Windows Defender on instances"
  type        = bool
  default     = true
}

variable "enable_windows_firewall" {
  description = "Enable Windows Firewall on instances"
  type        = bool
  default     = true
}

variable "antimalware_enabled" {
  description = "Enable anti-malware protection"
  type        = bool
  default     = true
}

variable "enable_bitlocker" {
  description = "Enable BitLocker encryption"
  type        = bool
  default     = false  # Requires additional configuration
}

###########################################
# LICENSING CONFIGURATION
###########################################

variable "windows_license_type" {
  description = "Windows license type (AHUB, PAYG)"
  type        = string
  default     = "PAYG"
  
  validation {
    condition     = contains(["AHUB", "PAYG"], var.windows_license_type)
    error_message = "Windows license type must be either AHUB or PAYG."
  }
}

variable "office_365_integration" {
  description = "Enable Office 365 integration"
  type        = bool
  default     = false
}

###########################################
# TAGGING CONFIGURATION
###########################################

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy    = "terraform"
    Environment  = "production"
    OS           = "Windows Server 2025"
    Criticality  = "High"
  }
}

variable "project_name" {
  description = "Project name for resource organization"
  type        = string
  default     = "hybrid-infrastructure"
}

variable "cost_center" {
  description = "Cost center for billing"
  type        = string
  default     = "IT-Infrastructure"
}

variable "owner" {
  description = "Resource owner email"
  type        = string
  default     = "infrastructure@company.com"
}