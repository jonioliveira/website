// Configure the Google Cloud provider
provider "google" {
  version     = "~> 3.26"
  credentials = file(var.credentials_path)
  project     = var.project
  region      = var.region
}

// Configure the Google Cloud Beta provider
provider "google-beta" {
  version     = "~> 3.26"
  credentials = file(var.credentials_path)
  project     = var.project
  region      = var.region
}

// Configure remote state
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "jonioliveira"

    workspaces {
      name = "tf-web-from-bucket"
    }
  }
}

// create remote id's for certificates
resource "random_id" "certificate" {
  byte_length = var.cert_byte_length
  prefix      = var.cert_prefix

  keepers = {
    domains = join(",", var.domains)
  }
}

#------------------------------------------------------
# Creation of service accounts is eventually consistent,
# and that can lead to errors when you try to apply ACLs
# to service accounts immediately after creation.
# If using these resources in the same config,
# you can add a sleep using local-exec.
#------------------------------------------------------
resource "google_service_account" "this" {
  project      = var.project
  account_id   = substr(var.name, 0, 28)
  display_name = var.name
}

resource "google_service_account_key" "this"{
  service_account_id = google_service_account.myaccount.name
}

#------------------------------------------------------
# Your bucket. We set the project id in its name because
# it needs to be unique among all existing projects in GCP, not just yours.
# We set our main page suffix to be the index.html,
# and the not found page to be our 404.html page.
#------------------------------------------------------

resource "google_storage_bucket" "assets" {
  name          = var.name
  location      = var.bucket_location
  storage_class = var.bucket_storage_class
  website {
    main_page_suffix = var.bucket_website_main
    not_found_page   = var.bucket_website_error
  }
}

#------------------------------------------------------
# add public read rights
#------------------------------------------------------
resource "google_storage_bucket_iam_member" "viewer" {
  bucket = google_storage_bucket.assets.name
  role   = var.bucket_viewer_access_role
  member = "allUsers"
}

#------------------------------------------------------
# Authoritative for a given role.
# Updates the IAM policy to grant a role to a
# list of members. Other roles within the
# IAM policy for the bucket are preserved.
#------------------------------------------------------
resource "google_storage_bucket_iam_binding" "owner" {
  bucket = google_storage_bucket.assets.name
  role   = var.bucket_sa_access_role
  members = [
    "serviceAccount:${google_service_account.this.email}",
  ]
}

#------------------------------------------------------
# Load Balancer
#------------------------------------------------------

#------------------------------------------------------
# Backend buckets define Google Cloud Storage buckets
# that can serve content. URL maps define which
# requests are sent to which backend buckets.
#------------------------------------------------------

resource "google_compute_backend_bucket" "assets" {
  name        = "${var.name}-compute-backend-bucket"
  bucket_name = google_storage_bucket.assets.name
  enable_cdn  = true
}

#------------------------------------------------------
# UrlMaps are used to route requests to a
# backend service based on rules that you define for
# the host and path of an incoming URL.
#------------------------------------------------------

resource "google_compute_url_map" "assets" {
  name            = "${var.name}-url-map"
  default_service = google_compute_backend_bucket.assets.self_link
}

#------------------------------------------------------
# Represents a Global Address resource.
# Global addresses are used for HTTP(S) load balancing.
#------------------------------------------------------
resource "google_compute_global_address" "assets" {
  name = "${var.name}-ip"
}

#------------------------------------------------------
# Represents a GlobalForwardingRule resource.
# Global forwarding rules are used to forward traffic
# to the correct load balancer for HTTP load balancing.
# Global forwarding rules can only be used for
# HTTP load balancing.
#------------------------------------------------------
resource "google_compute_global_forwarding_rule" "assets" {
  name       = "${var.name}-http-forward-rule"
  target     = google_compute_target_http_proxy.assets.self_link
  ip_address = google_compute_global_address.assets.address
  port_range = var.http_port
}

#------------------------------------------------------
# Represents a TargetHttpProxy resource, which is
# used by one or more global forwarding rule to
# route incoming HTTP requests to a URL map.
#------------------------------------------------------
resource "google_compute_target_http_proxy" "assets" {
  name    = "${var.name}-target-proxy"
  url_map = google_compute_url_map.assets.self_link
}

#------------------------------------------------------
# An SslCertificate resource, used for
# HTTPS load balancing. This resource represents a
# certificate for which the certificate secrets are
# created and managed by Google.
#------------------------------------------------------
resource "google_compute_managed_ssl_certificate" "https-cert" {
  provider = google-beta
  project  = var.project
  name     = random_id.certificate.hex

  lifecycle { create_before_destroy = true }
  managed {
    domains = local.managed_domains
  }
}

#------------------------------------------------------
# Represents a TargetHttpsProxy resource, which is
# used by one or more global forwarding rule to
# route incoming HTTPS requests to a URL map.
#------------------------------------------------------
resource "google_compute_target_https_proxy" "assets" {
  project          = var.project
  name             = "${var.name}-target-proxy"
  url_map          = google_compute_url_map.assets.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.https-cert.self_link]
}

#------------------------------------------------------
# Represents a GlobalForwardingRule resource.
# Global forwarding rules are used to forward traffic
# to the correct load balancer for HTTP load balancing.
# Global forwarding rules can only be used for
# HTTP load balancing.
#------------------------------------------------------
resource "google_compute_global_forwarding_rule" "https-assets" {
  name       = "${var.name}-https-forward-rule"
  target     = google_compute_target_https_proxy.assets.self_link
  ip_address = google_compute_global_address.assets.address
  port_range = var.https_port
}

