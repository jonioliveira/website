output "ip" {
  value = google_compute_global_address.assets.address
}

output "service_account_email" {
  value = google_service_account.this.email
}

output "service_account_key" {
  value = base64decode(google_service_account_key.this.private_key)
}
