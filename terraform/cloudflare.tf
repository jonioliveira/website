provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# ZONE
data "cloudflare_zones" "cf_zones" {
  filter {
    name = var.domain
  }
}

# DNS A RECORD
# Add a record to the domain
resource "cloudflare_record" "dns_record" {
  zone_id = data.cloudflare_zones.cf_zones.zones[0].id
  name    = "website"
  value   = google_compute_global_address.assets.address
  type    = "A"
  proxied = true
}
