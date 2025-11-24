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

# AWS credentials
variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

# vSphere credentials
variable "vsphere_username" {
  description = "vSphere username"
  type        = string
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}

# User management
variable "user_password" {
  description = "Password for new users"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

# Git integration
variable "git_username" {
  description = "Git username"
  type        = string
}

variable "git_token" {
  description = "Git access token"
  type        = string
  sensitive   = true
}

# Ansible integration
variable "ansible_username" {
  description = "Ansible username"
  type        = string
}

variable "ansible_password" {
  description = "Ansible password"
  type        = string
  sensitive   = true
}

# Domain credentials
variable "domain_username" {
  description = "Domain controller username"
  type        = string
}

variable "domain_password" {
  description = "Domain controller password"
  type        = string
  sensitive   = true
}

# SSH configuration
variable "ssh_passphrase" {
  description = "SSH key passphrase"
  type        = string
  sensitive   = true
  default     = ""
}