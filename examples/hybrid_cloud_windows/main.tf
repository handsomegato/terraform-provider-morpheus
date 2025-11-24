terraform {
  required_version = ">= 1.0"
  required_providers {
    morpheus = {
      source  = "gomorpheus/morpheus"
      version = "0.14.0"
    }
  }
}

# Provider configuration for hybrid cloud
provider "morpheus" {
  url      = var.morpheus_url
  username = var.morpheus_username
  password = var.morpheus_password
  secure   = var.morpheus_secure
}

###########################################
# ACTIVE DIRECTORY INTEGRATION
###########################################

# Active Directory Identity Source
resource "morpheus_active_directory_identity_source" "company_ad" {
  name        = "Company Active Directory"
  description = "Primary Active Directory for hybrid cloud authentication"
  ad_server   = var.ad_server
  domain      = var.ad_domain
  
  # Service account for AD operations
  binding_username = var.ad_service_username
  binding_password = var.ad_service_password
  
  # LDAP configuration
  search_base_dn = var.ad_search_base_dn
  user_fqn_expression = "{{username}}@${var.ad_domain}"
  
  # User and group mappings
  required_group_dn = var.ad_required_group_dn
  default_role_id   = data.morpheus_user_role.default_user.id
  
  # SSL configuration for secure LDAP
  use_ssl           = true
  ldap_port         = 636
  trust_store       = "internal"
  
  enabled = true
}

# Network Domain for Active Directory
resource "morpheus_network_domain" "ad_domain" {
  name                    = var.ad_domain
  description             = "Active Directory domain for hybrid cloud"
  fqdn                    = var.ad_domain
  join_domain_controller  = true
  visibility              = "private"
  
  # Domain Controller settings
  dc_server    = var.ad_dc_server
  username     = var.ad_admin_username
  password     = var.ad_admin_password
  
  # OU for computer accounts
  ou_path      = var.ad_computer_ou
  
  # DNS settings
  domain_controller = var.ad_dc_server
  domain_username   = var.ad_admin_username
  domain_password   = var.ad_admin_password
}

###########################################
# HYBRID CLOUD INFRASTRUCTURE
###########################################

# On-Premises vSphere Cloud
resource "morpheus_vsphere_cloud" "onprem_datacenter" {
  name        = "On-Premises Datacenter"
  description = "Primary on-premises vSphere infrastructure"
  location    = var.onprem_location
  visibility  = "private"
  tenant_id   = 1
  enabled     = true
  
  # vSphere connection
  api_url     = var.vsphere_url
  username    = var.vsphere_username
  password    = var.vsphere_password
  datacenter  = var.vsphere_datacenter
  cluster     = var.vsphere_cluster
  
  # Configuration
  resource_pool              = var.vsphere_resource_pool
  rpc_mode                  = "vmwaretools"
  hide_host_selection       = false
  import_existing           = true
  enable_hypervisor_console = true
  
  # Storage and networking
  storage_type = "standard"
  agent_mode   = "cloudInit"
  
  # Domain integration
  domain_id = morpheus_network_domain.ad_domain.id
  
  # Backup configuration
  backup_mode          = "internal"
  replication_mode     = "internal"
  security_mode        = "internal"
  certificate_provider = "internal"
}

# Azure Cloud for hybrid workloads
resource "morpheus_azure_cloud" "hybrid_azure" {
  name        = "Hybrid Azure Cloud"
  description = "Azure cloud for hybrid workloads"
  location    = var.azure_location
  visibility  = "private"
  tenant_id   = 1
  enabled     = true
  
  # Azure credentials
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id_azure = var.azure_tenant_id
  subscription_id = var.azure_subscription_id
  
  # Resource configuration
  resource_group     = var.azure_resource_group
  default_key_pair   = var.azure_key_pair
  
  # Network configuration
  security_mode = "internal"
  
  # Import existing resources
  import_existing = true
  
  # Backup settings
  backup_mode      = "internal"
  replication_mode = "internal"
}

###########################################
# WINDOWS SERVER DATACENTER 2025
###########################################

# Windows Server 2025 Instance Type
resource "morpheus_instance_type" "windows_server_2025" {
  name         = "Windows Server Datacenter 2025"
  description  = "Windows Server Datacenter 2025 instance type"
  code         = "windows-server-2025-datacenter"
  category     = "windows"
  featured     = true
  has_auto_scale = true
  has_deployment = true
  
  # Environment variables
  environment_variables = [
    {
      name         = "WINDOWS_VERSION"
      default_value = "2025"
      export       = true
    },
    {
      name         = "SERVER_ROLE"
      default_value = "datacenter"
      export       = true
    }
  ]
  
  # Option types for configuration
  option_types = [
    data.morpheus_option_type.windows_edition.id,
    data.morpheus_option_type.domain_join.id,
    data.morpheus_option_type.admin_password.id
  ]
}

# Instance Layout for Windows Server 2025
resource "morpheus_instance_layout" "windows_server_2025_layout" {
  instance_type_id = morpheus_instance_type.windows_server_2025.id
  name            = "Windows Server 2025 Standard"
  description     = "Standard Windows Server 2025 Datacenter layout"
  version         = "2025"
  creatable       = true
  enabled         = true
  sort_order      = 0
  
  # Provision type specific to cloud
  provision_type = "vmware"
  
  # Memory and storage configuration
  memory_requirement = 4096  # 4GB minimum
  has_auto_scale    = true
  supports_convert_to_managed = true
  
  # Container types (node types)
  container_types = [
    {
      id          = morpheus_node_type.windows_server_2025.id
      priority_order = 0
      can_add_nodes  = true
    }
  ]
  
  # Spec templates
  spec_templates = [
    {
      id = data.morpheus_spec_template.windows_vmware.id
    }
  ]
  
  # Actions and workflows
  actions = [
    {
      id   = data.morpheus_task.windows_domain_join.id
      name = "Domain Join"
    }
  ]
}

# Node Type for Windows Server 2025
resource "morpheus_node_type" "windows_server_2025" {
  name               = "Windows Server 2025 Datacenter VM"
  short_name         = "win2025dc"
  description        = "Windows Server 2025 Datacenter virtual machine"
  provision_type_code = "vmware"
  
  # VM specifications
  category           = "windows"
  technology         = "vmware"
  platform           = "windows"
  
  # Container ports and logs
  container_version  = "2025"
  entry_point       = ""
  mount_logs        = "/var/log"
  
  # Stateful configuration
  stateful_node     = true
  
  # Install agent
  container_scripts = [
    {
      id = data.morpheus_script_template.windows_agent_install.id
    }
  ]
  
  # Environment variables
  environment_variables = [
    {
      name  = "MORPHEUS_AGENT_PACKAGE"
      value = "windows"
    }
  ]
}

###########################################
# WINDOWS SERVER INSTANCES
###########################################

# Domain Controller Instance (On-Premises)
resource "morpheus_vsphere_instance" "domain_controller" {
  name               = "dc01-${var.environment}"
  description        = "Primary Domain Controller - Windows Server 2025"
  cloud_id           = morpheus_vsphere_cloud.onprem_datacenter.id
  group_id           = data.morpheus_group.infrastructure.id
  instance_type_id   = morpheus_instance_type.windows_server_2025.id
  instance_layout_id = morpheus_instance_layout.windows_server_2025_layout.id
  plan_id            = data.morpheus_plan.windows_medium.id
  environment        = var.environment
  
  # Network configuration
  interfaces {
    network_id = data.morpheus_network.infrastructure_vlan.id
    ip_address = var.dc_ip_address
  }
  
  # Storage configuration
  volumes {
    name         = "C:"
    size         = 100  # 100GB for OS
    datastore_id = data.morpheus_datastore.primary.id
    storage_type = "thick"
  }
  
  volumes {
    name         = "D:"
    size         = 50   # 50GB for data
    datastore_id = data.morpheus_datastore.primary.id
    storage_type = "thick"
  }
  
  # Tags and labels
  tags = {
    Role         = "domain-controller"
    Environment  = var.environment
    OS           = "Windows Server 2025"
    Criticality  = "High"
    BackupPolicy = "Daily"
    ManagedBy    = "terraform"
  }
  
  labels = ["domain-controller", "infrastructure", "windows", "critical"]
  
  # Environment variables
  evar {
    name   = "SERVER_ROLE"
    value  = "domain-controller"
    export = true
  }
  
  evar {
    name   = "DOMAIN_NAME"
    value  = var.ad_domain
    export = true
  }
  
  evar {
    name   = "SAFE_MODE_PASSWORD"
    value  = var.ad_safe_mode_password
    export = false
    masked = true
  }
  
  # Custom options
  custom_options = {
    "windows.adminPassword" = var.windows_admin_password
    "windows.domain"       = var.ad_domain
    "windows.domainJoin"   = "true"
    "windows.serverRole"   = "domain-controller"
  }
}

# File Server Instance (Hybrid - Azure)
resource "morpheus_aws_instance" "file_server" {
  name               = "fs01-${var.environment}"
  description        = "File Server - Windows Server 2025 in Azure"
  cloud_id           = morpheus_azure_cloud.hybrid_azure.id
  group_id           = data.morpheus_group.file_services.id
  instance_type_id   = morpheus_instance_type.windows_server_2025.id
  instance_layout_id = morpheus_instance_layout.windows_server_2025_layout.id
  plan_id            = data.morpheus_plan.windows_large.id
  environment        = var.environment
  
  # Network configuration
  interfaces {
    network_id = data.morpheus_network.azure_subnet.id
  }
  
  # Storage for file shares
  volumes {
    name = "C:"
    size = 100  # OS drive
  }
  
  volumes {
    name = "E:"
    size = 500  # File shares
  }
  
  volumes {
    name = "F:"
    size = 200  # User profiles
  }
  
  # Tags
  tags = {
    Role        = "file-server"
    Environment = var.environment
    OS          = "Windows Server 2025"
    Location    = "Azure"
    ManagedBy   = "terraform"
  }
  
  labels = ["file-server", "storage", "windows", "hybrid"]
  
  # Domain join configuration
  evar {
    name   = "DOMAIN_JOIN"
    value  = "true"
    export = true
  }
  
  evar {
    name   = "FILE_SHARE_PATH"
    value  = "E:\\Shares"
    export = true
  }
  
  custom_options = {
    "windows.adminPassword" = var.windows_admin_password
    "windows.domain"       = var.ad_domain
    "windows.domainJoin"   = "true"
    "windows.serverRole"   = "file-server"
    "azure.resourceGroup"  = var.azure_resource_group
  }
}

# IIS Web Server Instance (On-Premises)
resource "morpheus_vsphere_instance" "web_server" {
  name               = "web01-${var.environment}"
  description        = "IIS Web Server - Windows Server 2025"
  cloud_id           = morpheus_vsphere_cloud.onprem_datacenter.id
  group_id           = data.morpheus_group.web_services.id
  instance_type_id   = morpheus_instance_type.windows_server_2025.id
  instance_layout_id = morpheus_instance_layout.windows_server_2025_layout.id
  plan_id            = data.morpheus_plan.windows_medium.id
  environment        = var.environment
  
  interfaces {
    network_id = data.morpheus_network.dmz_vlan.id
  }
  
  volumes {
    name = "C:"
    size = 100
  }
  
  volumes {
    name = "D:"
    size = 100  # Web content
  }
  
  tags = {
    Role        = "web-server"
    Environment = var.environment
    OS          = "Windows Server 2025"
    Service     = "IIS"
    ManagedBy   = "terraform"
  }
  
  labels = ["web-server", "iis", "windows", "dmz"]
  
  evar {
    name   = "IIS_INSTALL"
    value  = "true"
    export = true
  }
  
  evar {
    name   = "WEB_ROOT"
    value  = "D:\\inetpub\\wwwroot"
    export = true
  }
  
  custom_options = {
    "windows.adminPassword" = var.windows_admin_password
    "windows.domain"       = var.ad_domain
    "windows.domainJoin"   = "true"
    "windows.serverRole"   = "web-server"
    "windows.features"     = "IIS-WebServerRole,IIS-WebServer,IIS-CommonHttpFeatures"
  }
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

data "morpheus_user_role" "default_user" {
  authority = "Standard User"
}

data "morpheus_plan" "windows_medium" {
  name           = "Windows Medium - 4 Core, 8GB Memory"
  provision_type = "VMware"
}

data "morpheus_plan" "windows_large" {
  name           = "Windows Large - 8 Core, 16GB Memory"
  provision_type = "Azure"
}

data "morpheus_network" "infrastructure_vlan" {
  name = "Infrastructure-VLAN"
}

data "morpheus_network" "dmz_vlan" {
  name = "DMZ-VLAN"
}

data "morpheus_network" "azure_subnet" {
  name = "Azure-Subnet"
}

data "morpheus_datastore" "primary" {
  name = "Primary-Datastore"
}

data "morpheus_option_type" "windows_edition" {
  name = "Windows Edition"
}

data "morpheus_option_type" "domain_join" {
  name = "Domain Join"
}

data "morpheus_option_type" "admin_password" {
  name = "Administrator Password"
}

data "morpheus_spec_template" "windows_vmware" {
  name = "Windows VMware Template"
}

data "morpheus_task" "windows_domain_join" {
  name = "Windows Domain Join"
}

data "morpheus_script_template" "windows_agent_install" {
  name = "Windows Agent Install"
}

###########################################
# OUTPUTS
###########################################

output "domain_controller_id" {
  description = "ID of the domain controller instance"
  value       = morpheus_vsphere_instance.domain_controller.id
}

output "file_server_id" {
  description = "ID of the file server instance"
  value       = morpheus_aws_instance.file_server.id
}

output "web_server_id" {
  description = "ID of the web server instance"
  value       = morpheus_vsphere_instance.web_server.id
}

output "active_directory_domain" {
  description = "Active Directory domain name"
  value       = var.ad_domain
}

output "hybrid_clouds" {
  description = "Configured hybrid clouds"
  value = {
    onprem = morpheus_vsphere_cloud.onprem_datacenter.name
    azure  = morpheus_azure_cloud.hybrid_azure.name
  }
}