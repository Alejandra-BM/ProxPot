# Provider configuration
terraform {
  #required_version = ">= 0.14"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc8"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url = ".../api2/json"
  pm_api_token_secret = "secretAPItoken"
  pm_api_token_id = "jjj@pam!ddd"
}
