terraform {
  required_version = ">= 0.13.0"

  // Configure remote state
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "jonioliveira"

    workspaces {
      name = "website"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 2.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "3.51.0"
    }
  }
}
