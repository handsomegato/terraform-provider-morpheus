# Multiple provider authentication examples

# Example 1: Username/Password Authentication
provider "morpheus" {
  url      = "https://your-morpheus.com"
  username = "admin"
  password = "your-password"
  secure   = true
}

# Example 2: Access Token Authentication
provider "morpheus" {
  url          = "https://your-morpheus.com"
  access_token = "your-access-token"
  secure       = true
}

# Example 3: Multi-tenant with subdomain
provider "morpheus" {
  url              = "https://your-morpheus.com"
  username         = "user@tenant"
  password         = "password"
  tenant_subdomain = "your-tenant"
  secure           = true
}

# Example 4: Insecure connection (for self-signed certificates)
provider "morpheus" {
  url      = "https://your-morpheus.com"
  username = "admin"
  password = "password"
  secure   = false  # Disables SSL verification
}

# Example 5: Using environment variables
# Set these environment variables:
# export MORPHEUS_URL="https://your-morpheus.com"
# export MORPHEUS_USERNAME="admin"
# export MORPHEUS_PASSWORD="password"
# export MORPHEUS_SECURE="true"

provider "morpheus" {
  # Configuration will be picked up from environment variables
  # MORPHEUS_URL, MORPHEUS_USERNAME, MORPHEUS_PASSWORD, MORPHEUS_SECURE
}

# Example 6: Complete configuration with all options
provider "morpheus" {
  url              = var.morpheus_url
  username         = var.morpheus_username
  password         = var.morpheus_password
  access_token     = var.morpheus_access_token     # Optional
  refresh_token    = var.morpheus_refresh_token    # Optional
  tenant_subdomain = var.morpheus_tenant_subdomain # Optional
  secure           = var.morpheus_secure           # Default: true
}