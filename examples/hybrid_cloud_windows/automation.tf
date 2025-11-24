# Windows Server 2025 Automation Tasks and Workflows

terraform {
  required_providers {
    morpheus = {
      source  = "gomorpheus/morpheus"
      version = "0.14.0"
    }
  }
}

###########################################
# WINDOWS SCRIPT TEMPLATES
###########################################

# Domain Join Script Template
resource "morpheus_script_template" "domain_join_script" {
  name         = "Windows Domain Join Script"
  description  = "PowerShell script to join Windows Server to Active Directory domain"
  script_type  = "powershell"
  script_phase = "provision"
  
  script_content = <<-EOT
# Windows Domain Join Script for Server 2025
param(
    [Parameter(Mandatory=$true)]
    [string]$DomainName,
    
    [Parameter(Mandatory=$true)]
    [string]$Username,
    
    [Parameter(Mandatory=$true)]
    [string]$Password,
    
    [string]$OUPath = $null
)

# Enable logging
Start-Transcript -Path "C:\Windows\Temp\domain_join.log" -Append

try {
    Write-Host "Starting domain join process for domain: $DomainName"
    
    # Create credential object
    $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential($Username, $SecurePassword)
    
    # Check if already domain joined
    if ((Get-WmiObject -Class Win32_ComputerSystem).Domain -eq $DomainName) {
        Write-Host "Computer is already joined to domain $DomainName"
        exit 0
    }
    
    # Join domain
    $JoinParams = @{
        DomainName = $DomainName
        Credential = $Credential
        Force = $true
        Restart = $false
    }
    
    if ($OUPath) {
        $JoinParams.OUPath = $OUPath
    }
    
    Add-Computer @JoinParams
    
    Write-Host "Domain join successful. Computer will restart automatically."
    
    # Configure Windows Update to use WSUS if available
    $WSUSServer = "http://wsus.${DomainName}:8530"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "WUServer" -Value $WSUSServer -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "WUStatusServer" -Value $WSUSServer -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "UseWUServer" -Value 1 -Force
    
    # Schedule restart
    shutdown /r /t 60 /c "Restarting after domain join"
    
} catch {
    Write-Error "Domain join failed: $($_.Exception.Message)"
    exit 1
} finally {
    Stop-Transcript
}
EOT
}

# IIS Installation Script
resource "morpheus_script_template" "iis_install_script" {
  name         = "IIS Installation Script"
  description  = "Install and configure IIS on Windows Server 2025"
  script_type  = "powershell"
  script_phase = "provision"
  
  script_content = <<-EOT
# IIS Installation Script for Windows Server 2025
Start-Transcript -Path "C:\Windows\Temp\iis_install.log" -Append

try {
    Write-Host "Installing IIS and related features..."
    
    # Install IIS with common features
    $Features = @(
        "IIS-WebServerRole",
        "IIS-WebServer", 
        "IIS-CommonHttpFeatures",
        "IIS-HttpErrors",
        "IIS-HttpLogging",
        "IIS-HttpRedirect",
        "IIS-ApplicationDevelopment",
        "IIS-NetFxExtensibility45",
        "IIS-NetFxExtensibility",
        "IIS-HealthAndDiagnostics",
        "IIS-HttpLogging",
        "IIS-Security",
        "IIS-RequestFiltering",
        "IIS-Performance",
        "IIS-WebServerManagementTools",
        "IIS-ManagementConsole",
        "IIS-IIS6ManagementCompatibility",
        "IIS-Metabase",
        "IIS-ASPNET45",
        "IIS-ASPNET"
    )
    
    foreach ($Feature in $Features) {
        Write-Host "Installing feature: $Feature"
        Enable-WindowsOptionalFeature -Online -FeatureName $Feature -All
    }
    
    # Configure default website
    Import-Module WebAdministration
    
    # Remove default website
    Remove-Website -Name "Default Web Site"
    
    # Create new default site
    $SitePath = "D:\inetpub\wwwroot"
    if (!(Test-Path $SitePath)) {
        New-Item -ItemType Directory -Path $SitePath -Force
    }
    
    New-Website -Name "Default Web Site" -Port 80 -PhysicalPath $SitePath
    
    # Create a simple default page
    $DefaultPage = @"
<!DOCTYPE html>
<html>
<head>
    <title>Windows Server 2025 - IIS</title>
</head>
<body>
    <h1>Welcome to Windows Server 2025</h1>
    <p>IIS is successfully installed and configured.</p>
    <p>Server: $env:COMPUTERNAME</p>
    <p>Timestamp: $(Get-Date)</p>
</body>
</html>
"@
    
    $DefaultPage | Out-File -FilePath "$SitePath\index.html" -Encoding UTF8
    
    # Configure logging
    Set-WebConfigurationProperty -Filter "system.webServer/httpLogging" -Name "enabled" -Value $true
    Set-WebConfigurationProperty -Filter "system.webServer/httpLogging" -Name "logFormat" -Value "W3C"
    
    # Enable compression
    Set-WebConfigurationProperty -Filter "system.webServer/httpCompression" -Name "enabled" -Value $true
    
    # Configure security headers
    Add-WebConfigurationProperty -Filter "system.webServer/httpProtocol/customHeaders" -Name "." -Value @{name="X-Content-Type-Options"; value="nosniff"}
    Add-WebConfigurationProperty -Filter "system.webServer/httpProtocol/customHeaders" -Name "." -Value @{name="X-Frame-Options"; value="SAMEORIGIN"}
    
    # Start services
    Start-Service W3SVC
    Start-Service WAS
    
    # Configure firewall
    New-NetFirewallRule -DisplayName "IIS HTTP" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow
    New-NetFirewallRule -DisplayName "IIS HTTPS" -Direction Inbound -Protocol TCP -LocalPort 443 -Action Allow
    
    Write-Host "IIS installation and configuration completed successfully."
    
} catch {
    Write-Error "IIS installation failed: $($_.Exception.Message)"
    exit 1
} finally {
    Stop-Transcript
}
EOT
}

# File Server Configuration Script
resource "morpheus_script_template" "file_server_setup" {
  name         = "File Server Setup Script"
  description  = "Configure Windows Server 2025 as a file server"
  script_type  = "powershell"
  script_phase = "provision"
  
  script_content = <<-EOT
# File Server Configuration Script
param(
    [string]$SharePath = "E:\Shares",
    [string]$UserProfilePath = "F:\UserProfiles"
)

Start-Transcript -Path "C:\Windows\Temp\fileserver_setup.log" -Append

try {
    Write-Host "Configuring Windows Server 2025 as File Server..."
    
    # Install File Server role
    Install-WindowsFeature -Name FS-FileServer, FS-DFS-Namespace, FS-DFS-Replication -IncludeManagementTools
    
    # Create share directories
    if (!(Test-Path $SharePath)) {
        New-Item -ItemType Directory -Path $SharePath -Force
        Write-Host "Created share directory: $SharePath"
    }
    
    if (!(Test-Path $UserProfilePath)) {
        New-Item -ItemType Directory -Path $UserProfilePath -Force
        Write-Host "Created user profiles directory: $UserProfilePath"
    }
    
    # Create company shares
    $CompanyShares = @(
        @{Name="CompanyData"; Path="$SharePath\CompanyData"; Description="Company shared data"},
        @{Name="Software"; Path="$SharePath\Software"; Description="Software repository"},
        @{Name="Templates"; Path="$SharePath\Templates"; Description="Document templates"},
        @{Name="Projects"; Path="$SharePath\Projects"; Description="Project files"}
    )
    
    foreach ($Share in $CompanyShares) {
        $ShareDir = $Share.Path
        if (!(Test-Path $ShareDir)) {
            New-Item -ItemType Directory -Path $ShareDir -Force
        }
        
        # Create SMB share
        New-SmbShare -Name $Share.Name -Path $ShareDir -Description $Share.Description -FullAccess "Domain Admins" -ReadAccess "Domain Users"
        Write-Host "Created share: $($Share.Name) at $ShareDir"
    }
    
    # Create user profile share
    New-SmbShare -Name "UserProfiles$" -Path $UserProfilePath -Description "User Profiles" -FullAccess "Domain Admins", "SYSTEM"
    
    # Configure NTFS permissions for shares
    # Company Data - Read/Write for Domain Users
    $Acl = Get-Acl "$SharePath\CompanyData"
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Domain Users","Modify","ContainerInherit,ObjectInherit","None","Allow")
    $Acl.SetAccessRule($AccessRule)
    Set-Acl -Path "$SharePath\CompanyData" -AclObject $Acl
    
    # Software - Read-only for Domain Users, Full for IT group
    $Acl = Get-Acl "$SharePath\Software"
    $ReadRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Domain Users","ReadAndExecute","ContainerInherit,ObjectInherit","None","Allow")
    $AdminRule = New-Object System.Security.AccessControl.FileSystemAccessRule("IT Administrators","FullControl","ContainerInherit,ObjectInherit","None","Allow")
    $Acl.SetAccessRule($ReadRule)
    $Acl.SetAccessRule($AdminRule)
    Set-Acl -Path "$SharePath\Software" -AclObject $Acl
    
    # Configure SMB settings for performance
    Set-SmbServerConfiguration -EnableSMB2Protocol $true -Confirm:$false
    Set-SmbServerConfiguration -EnableLeasing $true -Confirm:$false
    Set-SmbServerConfiguration -EnableOpLocks $true -Confirm:$false
    
    # Configure file screening (optional)
    # Install-WindowsFeature -Name FS-Resource-Manager -IncludeManagementTools
    
    # Configure firewall rules
    Enable-NetFirewallRule -DisplayName "File and Printer Sharing (SMB-In)"
    Enable-NetFirewallRule -DisplayName "File and Printer Sharing (NB-Session-In)"
    Enable-NetFirewallRule -DisplayName "File and Printer Sharing (NB-Name-In)"
    
    # Configure auditing for file access
    auditpol /set /category:"Object Access" /success:enable /failure:enable
    
    Write-Host "File server configuration completed successfully."
    Write-Host "Available shares:"
    Get-SmbShare | Where-Object {$_.Name -ne "ADMIN$" -and $_.Name -ne "C$" -and $_.Name -ne "IPC$"} | Format-Table Name, Path, Description
    
} catch {
    Write-Error "File server configuration failed: $($_.Exception.Message)"
    exit 1
} finally {
    Stop-Transcript
}
EOT
}

# Windows Security Hardening Script
resource "morpheus_script_template" "windows_security_hardening" {
  name         = "Windows Security Hardening"
  description  = "Apply security hardening to Windows Server 2025"
  script_type  = "powershell"
  script_phase = "postProvision"
  
  script_content = <<-EOT
# Windows Server 2025 Security Hardening Script
Start-Transcript -Path "C:\Windows\Temp\security_hardening.log" -Append

try {
    Write-Host "Applying Windows Server 2025 security hardening..."
    
    # Enable Windows Defender
    Set-MpPreference -DisableRealtimeMonitoring $false
    Set-MpPreference -SubmitSamplesConsent SendSafeSamples
    Update-MpSignature
    
    # Configure Windows Firewall
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
    Set-NetFirewallProfile -Profile Domain,Public,Private -DefaultInboundAction Block
    Set-NetFirewallProfile -Profile Domain,Public,Private -DefaultOutboundAction Allow
    
    # Disable unnecessary services
    $ServicesToDisable = @(
        "Fax",
        "TelNet", 
        "SNMP",
        "RemoteRegistry",
        "Spooler"  # Disable if not needed
    )
    
    foreach ($Service in $ServicesToDisable) {
        $ServiceObj = Get-Service -Name $Service -ErrorAction SilentlyContinue
        if ($ServiceObj) {
            Stop-Service -Name $Service -Force
            Set-Service -Name $Service -StartupType Disabled
            Write-Host "Disabled service: $Service"
        }
    }
    
    # Configure account policies
    secedit /export /cfg C:\Windows\Temp\secpol.cfg
    
    # Modify security policies
    (Get-Content C:\Windows\Temp\secpol.cfg) -replace "PasswordComplexity = 0", "PasswordComplexity = 1" | Set-Content C:\Windows\Temp\secpol.cfg
    (Get-Content C:\Windows\Temp\secpol.cfg) -replace "MinimumPasswordLength = 0", "MinimumPasswordLength = 12" | Set-Content C:\Windows\Temp\secpol.cfg
    (Get-Content C:\Windows\Temp\secpol.cfg) -replace "MaximumPasswordAge = -1", "MaximumPasswordAge = 90" | Set-Content C:\Windows\Temp\secpol.cfg
    (Get-Content C:\Windows\Temp\secpol.cfg) -replace "LockoutBadCount = 0", "LockoutBadCount = 5" | Set-Content C:\Windows\Temp\secpol.cfg
    
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\Windows\Temp\secpol.cfg
    Remove-Item C:\Windows\Temp\secpol.cfg
    
    # Configure audit policies
    auditpol /set /category:"Logon/Logoff" /success:enable /failure:enable
    auditpol /set /category:"Object Access" /success:enable /failure:enable
    auditpol /set /category:"Policy Change" /success:enable /failure:enable
    auditpol /set /category:"Account Management" /success:enable /failure:enable
    auditpol /set /category:"System" /success:enable /failure:enable
    
    # Configure event log sizes
    wevtutil sl Security /ms:1024000000  # 1GB
    wevtutil sl System /ms:512000000     # 512MB
    wevtutil sl Application /ms:512000000 # 512MB
    
    # Disable unnecessary protocols
    Disable-WindowsOptionalFeature -Online -FeatureName "SMB1Protocol" -NoRestart
    
    # Configure registry settings for security
    # Disable anonymous SID enumeration
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "RestrictAnonymousSAM" -Value 1
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "RestrictAnonymous" -Value 1
    
    # Configure session security
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" -Name "NTLMMinClientSec" -Value 537395200
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" -Name "NTLMMinServerSec" -Value 537395200
    
    # Disable LM hash storage
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "NoLMHash" -Value 1
    
    # Configure remote access
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 1
    
    # Enable DEP for all programs
    bcdedit /set {current} nx AlwaysOn
    
    # Configure SMB settings
    Set-SmbServerConfiguration -EnableSMB1Protocol $false -Confirm:$false
    Set-SmbServerConfiguration -RequireSecuritySignature $true -Confirm:$false
    Set-SmbClientConfiguration -RequireSecuritySignature $true -Confirm:$false
    
    Write-Host "Security hardening completed successfully."
    
} catch {
    Write-Error "Security hardening failed: $($_.Exception.Message)"
    exit 1
} finally {
    Stop-Transcript
}
EOT
}

###########################################
# POWERSHELL TASK RESOURCES
###########################################

# Domain Join Task
resource "morpheus_powershell_script_task" "domain_join_task" {
  name               = "Windows Domain Join"
  description        = "Join Windows server to Active Directory domain"
  labels             = ["domain", "active-directory", "windows"]
  script_content     = morpheus_script_template.domain_join_script.script_content
  sudo               = true
  retryable          = true
  retry_count        = 3
  retry_delay_seconds = 60
  allow_custom_config = true
  
  option_types = [
    data.morpheus_option_type.domain_name.id,
    data.morpheus_option_type.domain_username.id,
    data.morpheus_option_type.domain_password.id,
    data.morpheus_option_type.ou_path.id
  ]
}

# IIS Installation Task
resource "morpheus_powershell_script_task" "iis_install_task" {
  name               = "Install IIS"
  description        = "Install and configure IIS on Windows Server"
  labels             = ["iis", "web-server", "windows"]
  script_content     = morpheus_script_template.iis_install_script.script_content
  sudo               = true
  retryable          = true
  retry_count        = 2
  allow_custom_config = true
}

# File Server Setup Task
resource "morpheus_powershell_script_task" "file_server_task" {
  name               = "Configure File Server"
  description        = "Configure Windows Server as file server"
  labels             = ["file-server", "shares", "windows"]
  script_content     = morpheus_script_template.file_server_setup.script_content
  sudo               = true
  retryable          = true
  retry_count        = 2
  allow_custom_config = true
}

# Security Hardening Task
resource "morpheus_powershell_script_task" "security_hardening_task" {
  name               = "Windows Security Hardening"
  description        = "Apply security hardening to Windows Server"
  labels             = ["security", "hardening", "windows"]
  script_content     = morpheus_script_template.windows_security_hardening.script_content
  sudo               = true
  retryable          = false
  allow_custom_config = true
}

###########################################
# WORKFLOWS
###########################################

# Windows Server Deployment Workflow
resource "morpheus_provisioning_workflow" "windows_deployment" {
  name        = "Windows Server 2025 Deployment"
  description = "Complete deployment workflow for Windows Server 2025"
  labels      = ["deployment", "windows", "automation"]
  
  option_types = [
    data.morpheus_option_type.server_role.id,
    data.morpheus_option_type.domain_join_option.id,
    data.morpheus_option_type.install_iis.id,
    data.morpheus_option_type.configure_file_server.id
  ]
  
  tasks = [
    {
      task_id    = morpheus_powershell_script_task.security_hardening_task.id
      task_phase = "postProvision"
    },
    {
      task_id    = morpheus_powershell_script_task.domain_join_task.id
      task_phase = "postProvision"
    }
  ]
}

# IIS Web Server Workflow
resource "morpheus_provisioning_workflow" "iis_web_server" {
  name        = "IIS Web Server Setup"
  description = "Deploy and configure IIS web server"
  labels      = ["iis", "web-server", "windows"]
  
  tasks = [
    {
      task_id    = morpheus_powershell_script_task.security_hardening_task.id
      task_phase = "postProvision"
    },
    {
      task_id    = morpheus_powershell_script_task.domain_join_task.id
      task_phase = "postProvision"
    },
    {
      task_id    = morpheus_powershell_script_task.iis_install_task.id
      task_phase = "postProvision"
    }
  ]
}

# File Server Workflow
resource "morpheus_provisioning_workflow" "file_server_workflow" {
  name        = "File Server Setup"
  description = "Deploy and configure Windows file server"
  labels      = ["file-server", "storage", "windows"]
  
  tasks = [
    {
      task_id    = morpheus_powershell_script_task.security_hardening_task.id
      task_phase = "postProvision"
    },
    {
      task_id    = morpheus_powershell_script_task.domain_join_task.id
      task_phase = "postProvision"
    },
    {
      task_id    = morpheus_powershell_script_task.file_server_task.id
      task_phase = "postProvision"
    }
  ]
}

###########################################
# DATA SOURCES FOR OPTION TYPES
###########################################

data "morpheus_option_type" "domain_name" {
  name = "Domain Name"
}

data "morpheus_option_type" "domain_username" {
  name = "Domain Username"
}

data "morpheus_option_type" "domain_password" {
  name = "Domain Password"
}

data "morpheus_option_type" "ou_path" {
  name = "Organizational Unit Path"
}

data "morpheus_option_type" "server_role" {
  name = "Server Role"
}

data "morpheus_option_type" "domain_join_option" {
  name = "Domain Join"
}

data "morpheus_option_type" "install_iis" {
  name = "Install IIS"
}

data "morpheus_option_type" "configure_file_server" {
  name = "Configure File Server"
}

###########################################
# OUTPUTS
###########################################

output "automation_tasks" {
  description = "Created automation tasks"
  value = {
    domain_join      = morpheus_powershell_script_task.domain_join_task.name
    iis_install      = morpheus_powershell_script_task.iis_install_task.name
    file_server      = morpheus_powershell_script_task.file_server_task.name
    security_hardening = morpheus_powershell_script_task.security_hardening_task.name
  }
}

output "workflows" {
  description = "Created workflows"
  value = {
    windows_deployment = morpheus_provisioning_workflow.windows_deployment.name
    iis_web_server     = morpheus_provisioning_workflow.iis_web_server.name
    file_server        = morpheus_provisioning_workflow.file_server_workflow.name
  }
}

output "script_templates" {
  description = "Created script templates"
  value = {
    domain_join         = morpheus_script_template.domain_join_script.name
    iis_install         = morpheus_script_template.iis_install_script.name
    file_server_setup   = morpheus_script_template.file_server_setup.name
    security_hardening  = morpheus_script_template.windows_security_hardening.name
  }
}