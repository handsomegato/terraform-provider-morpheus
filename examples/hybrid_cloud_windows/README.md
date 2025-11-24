# Windows Server 2025 Hybrid Cloud Infrastructure with Morpheus

This directory contains Terraform configurations specifically designed for deploying and managing Windows Server Datacenter 2025 in a hybrid cloud environment using Morpheus.

## 🏗️ Architecture Overview

This configuration sets up:
- **Active Directory Integration** with LDAP/AD authentication
- **Hybrid Cloud Infrastructure** (On-premises vSphere + Azure)
- **Windows Server 2025 Datacenter** instances with domain joining
- **Automated Workflows** for server provisioning and configuration
- **Security Policies** and governance for Windows environments
- **Role-based Server Deployment** (Domain Controllers, File Servers, Web Servers)

## 📁 File Structure

```
hybrid_cloud_windows/
├── main.tf                    # Main infrastructure configuration
├── variables.tf               # Variable definitions
├── policies.tf                # Windows-specific policies and governance
├── automation.tf              # PowerShell tasks and workflows
├── terraform.tfvars.example   # Example variable values
└── README.md                  # This file
```

## 🎯 Key Components

### 1. Active Directory Integration
- **LDAP Identity Source** for user authentication
- **Network Domain** configuration for automatic domain joining
- **Computer Account Management** with OU placement
- **Group Policy** integration capabilities

### 2. Hybrid Cloud Infrastructure
- **On-Premises vSphere** for domain controllers and core services
- **Azure Cloud** for scalable workloads and hybrid scenarios
- **Cross-platform Networking** with domain connectivity
- **Unified Management** through Morpheus

### 3. Windows Server 2025 Resources
- **Custom Instance Types** for Windows Server 2025 Datacenter
- **Instance Layouts** optimized for different server roles
- **Node Types** with Windows-specific configurations
- **Automated Agent Installation** and domain joining

### 4. Server Role Configurations
- **Domain Controller** (On-premises, highly available)
- **File Server** (Hybrid Azure, with SMB shares)
- **IIS Web Server** (On-premises DMZ, hardened)

## 🚀 Quick Start

### Prerequisites
- Morpheus platform access with admin privileges
- vSphere environment with appropriate permissions
- Azure subscription with service principal
- Active Directory environment
- Windows Server 2025 templates/images

### 1. Configure Variables
```bash
# Copy example configuration
cp terraform.tfvars.example terraform.tfvars

# Edit with your environment details
nano terraform.tfvars
```

### 2. Initialize and Deploy
```bash
# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Deploy infrastructure
terraform apply
```

### 3. Verify Deployment
- Check Active Directory integration
- Verify domain joining functionality
- Test role-specific configurations
- Validate security policies

## 🔧 Configuration Details

### Active Directory Integration

```hcl
# Example AD configuration
ad_domain               = "company.local"
ad_server              = "dc01.company.local"
ad_service_username    = "svc-morpheus@company.local"
ad_search_base_dn      = "DC=company,DC=local"
ad_computer_ou         = "OU=Servers,DC=company,DC=local"
```

### Hybrid Cloud Setup

```hcl
# vSphere for on-premises
vsphere_url           = "https://vcenter.company.local/sdk"
vsphere_datacenter    = "Corporate-DC"
vsphere_cluster       = "Production-Cluster"

# Azure for hybrid workloads  
azure_location        = "East US"
azure_resource_group  = "morpheus-hybrid-prod-rg"
```

### Windows Server Roles

The configuration supports multiple server roles:

1. **Domain Controller**
   - Primary AD services
   - DNS and DHCP
   - High availability configuration

2. **File Server**
   - SMB/CIFS shares
   - User profile storage
   - DFS namespace support

3. **Web Server**
   - IIS with .NET Framework
   - SSL certificate management
   - Load balancing ready

## 🛡️ Security Features

### Built-in Security Hardening
- Windows Defender configuration
- Windows Firewall rules
- Account lockout policies
- Audit policy configuration
- SMB security settings
- Registry security tweaks

### Compliance Policies
- Hostname naming conventions
- Backup requirements
- Resource limits and quotas
- Approval workflows
- License compliance tracking

### Domain Security
- Secure LDAP (LDAPS) configuration
- Computer account management
- Group policy enforcement
- Certificate-based authentication

## 🔄 Automation Workflows

### PowerShell Scripts Include:
- **Domain Join Script** - Automated AD domain joining
- **IIS Installation** - Complete web server setup
- **File Server Setup** - Share creation and permissions
- **Security Hardening** - CIS-based security configuration

### Workflow Examples:
```hcl
# Domain Controller Deployment
morpheus_provisioning_workflow.windows_deployment

# Web Server with IIS
morpheus_provisioning_workflow.iis_web_server  

# File Server Configuration
morpheus_provisioning_workflow.file_server_workflow
```

## 📊 Monitoring and Compliance

### Policy Enforcement
- **Budget Controls** - Monthly spending limits
- **Resource Quotas** - CPU, memory, storage limits
- **Security Compliance** - Windows security baselines
- **Backup Policies** - Automated daily backups

### Tagging Strategy
```hcl
tags = {
  Environment   = "production"
  OS           = "Windows Server 2025"  
  Role         = "domain-controller"
  Criticality  = "High"
  ManagedBy    = "terraform"
  BackupPolicy = "Daily"
}
```

## 🔍 Troubleshooting

### Common Issues

1. **Domain Join Failures**
   - Verify AD service account permissions
   - Check network connectivity to domain controllers
   - Validate OU permissions for computer account creation

2. **Azure Hybrid Connectivity**
   - Confirm service principal permissions
   - Verify resource group access
   - Check network security group rules

3. **PowerShell Execution**
   - Validate execution policy settings
   - Check PowerShell version compatibility
   - Review script error logs in C:\Windows\Temp\

### Log Locations
```
Domain Join: C:\Windows\Temp\domain_join.log
IIS Setup: C:\Windows\Temp\iis_install.log
File Server: C:\Windows\Temp\fileserver_setup.log
Security: C:\Windows\Temp\security_hardening.log
```

## 📈 Scaling and Performance

### Horizontal Scaling
- Add additional file servers in different regions
- Deploy multiple web servers behind load balancers
- Implement read-only domain controllers

### Performance Optimization
- SSD storage for database workloads
- Memory optimization for file caching
- Network optimization for hybrid connectivity

## 🔐 Security Best Practices

### Implementation Guidelines
1. **Change Default Passwords** - Use strong, unique passwords
2. **Enable MFA** - Multi-factor authentication for admin accounts
3. **Regular Updates** - Windows Update and patch management
4. **Backup Verification** - Regular backup testing and validation
5. **Security Monitoring** - Implement SIEM integration

### Compliance Features
- **CIS Benchmarks** - Security configuration baselines
- **NIST Framework** - Risk management alignment
- **SOC 2** - Security control implementation
- **HIPAA/PCI** - Data protection measures

## 📚 Additional Resources

- [Windows Server 2025 Documentation](https://docs.microsoft.com/en-us/windows-server/)
- [Active Directory Best Practices](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/)
- [Azure Hybrid Cloud](https://azure.microsoft.com/en-us/solutions/hybrid-cloud-app/)
- [Morpheus Documentation](https://docs.morpheusdata.com/)
- [PowerShell DSC](https://docs.microsoft.com/en-us/powershell/scripting/dsc/)

## 🤝 Support

For issues and questions:
- Create GitHub issues for bugs or feature requests
- Contact your Morpheus administrator for platform-specific issues
- Consult Windows Server documentation for OS-specific problems

---

**Note**: This configuration is designed for production environments. Ensure proper testing in development/staging environments before deploying to production.