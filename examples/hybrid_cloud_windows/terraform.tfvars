# Windows Server 2025 Hybrid Cloud Infrastructure Configuration
# ⚠️  IMPORTANT: Update these values with your actual environment details before deploying!

# Morpheus Configuration - UPDATE THESE VALUES
morpheus_url      = "https://your-morpheus-instance.com"     # ← UPDATE: Your Morpheus URL
morpheus_username = "admin"                                  # ← UPDATE: Your Morpheus username  
morpheus_password = "your-secure-password"                   # ← UPDATE: Your Morpheus password
morpheus_secure   = true

# Environment
environment = "prod"

###########################################
# ACTIVE DIRECTORY CONFIGURATION - UPDATE ALL OF THESE
###########################################
ad_domain               = "company.local"                           # ← UPDATE: Your AD domain
ad_server              = "dc01.company.local"                      # ← UPDATE: Your AD server FQDN
ad_dc_server           = "dc01.company.local"                      # ← UPDATE: Your DC FQDN
ad_service_username    = "svc-morpheus@company.local"              # ← UPDATE: Service account
ad_service_password    = "ServiceAccount123!"                      # ← UPDATE: Service account password
ad_admin_username      = "Administrator@company.local"             # ← UPDATE: Domain admin
ad_admin_password      = "DomainAdmin123!"                         # ← UPDATE: Domain admin password
ad_search_base_dn      = "DC=company,DC=local"                     # ← UPDATE: Your search base DN
ad_required_group_dn   = "CN=Morpheus Users,OU=Security Groups,DC=company,DC=local"  # ← UPDATE: Required group
ad_computer_ou         = "OU=Servers,OU=Computers,DC=company,DC=local"               # ← UPDATE: Computer OU
ad_safe_mode_password  = "SafeMode123!"                            # ← UPDATE: DSRM password

###########################################
# ON-PREMISES VSPHERE CONFIGURATION - UPDATE ALL OF THESE
###########################################
onprem_location       = "Corporate Datacenter - Building A"         # ← UPDATE: Your location
vsphere_url           = "https://vcenter.company.local/sdk"         # ← UPDATE: vCenter URL
vsphere_username      = "morpheus-svc@company.local"               # ← UPDATE: vSphere service account
vsphere_password      = "vSphereService123!"                       # ← UPDATE: vSphere password
vsphere_datacenter    = "Corporate-DC"                             # ← UPDATE: Datacenter name
vsphere_cluster       = "Production-Cluster"                       # ← UPDATE: Cluster name
vsphere_resource_pool = "Production-Pool"                          # ← UPDATE: Resource pool

###########################################
# AZURE HYBRID CONFIGURATION - UPDATE ALL OF THESE
###########################################
azure_location        = "East US"                                  # ← UPDATE: Azure region
azure_client_id       = "12345678-1234-1234-1234-123456789012"    # ← UPDATE: Service principal client ID
azure_client_secret   = "azure-service-principal-secret"          # ← UPDATE: Service principal secret
azure_tenant_id       = "87654321-4321-4321-4321-210987654321"    # ← UPDATE: Azure tenant ID
azure_subscription_id = "abcdef12-3456-7890-abcd-ef1234567890"    # ← UPDATE: Azure subscription ID
azure_resource_group  = "morpheus-hybrid-prod-rg"                 # ← UPDATE: Resource group name
azure_key_pair        = "morpheus-azure-keypair"                  # ← UPDATE: SSH key pair name

###########################################
# WINDOWS SERVER 2025 CONFIGURATION
###########################################
windows_admin_password = "Windows2025Admin!@#"                     # ← UPDATE: Strong Windows admin password
dc_ip_address         = "10.0.100.10"                             # ← UPDATE: DC static IP

# Instance Sizing (adjust as needed)
dc_cpu_cores    = 4
dc_memory_gb    = 8
dc_storage_gb   = 150

fs_cpu_cores    = 6
fs_memory_gb    = 16
fs_storage_gb   = 1000

web_cpu_cores   = 4
web_memory_gb   = 8
web_storage_gb  = 200

###########################################
# NETWORK CONFIGURATION - UPDATE THESE
###########################################
infrastructure_vlan_id = 100                                       # ← UPDATE: Your infrastructure VLAN ID
dmz_vlan_id           = 200                                        # ← UPDATE: Your DMZ VLAN ID
infrastructure_subnet  = "10.0.100.0/24"                          # ← UPDATE: Infrastructure subnet
dmz_subnet            = "10.0.200.0/24"                           # ← UPDATE: DMZ subnet

###########################################
# BACKUP AND MONITORING
###########################################
backup_enabled        = true
backup_retention_days = 30
monitoring_enabled    = true

###########################################
# SECURITY CONFIGURATION
###########################################
enable_windows_defender  = true
enable_windows_firewall  = true
antimalware_enabled     = true
enable_bitlocker        = false

###########################################
# LICENSING CONFIGURATION
###########################################
windows_license_type    = "AHUB"  # Use Azure Hybrid Benefit (or "PAYG" for Pay As You Go)
office_365_integration = true

###########################################
# TAGGING CONFIGURATION - UPDATE THESE
###########################################
default_tags = {
  ManagedBy     = "terraform"
  Environment   = "production"
  OS            = "Windows Server 2025"
  Criticality   = "High"
  BackupPolicy  = "Daily"
  Department    = "IT Infrastructure"                              # ← UPDATE: Your department
  CostCenter    = "IT-INFRA-001"                                   # ← UPDATE: Your cost center
  Owner         = "infrastructure-team@company.com"               # ← UPDATE: Your team email
}

project_name = "hybrid-infrastructure-2025"                        # ← UPDATE: Your project name
cost_center  = "IT-INFRA-001"                                     # ← UPDATE: Your cost center
owner        = "infrastructure-team@company.com"                  # ← UPDATE: Your email