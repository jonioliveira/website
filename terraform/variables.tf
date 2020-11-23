variable project {
  type = string
}

variable region {
  type = string
}

variable name {
  type = string
}

variable bucket_location {
  type = string
}

variable bucket_storage_class {
  type    = string
  default = "MULTI_REGIONAL"
}

variable bucket_website_main {
  type    = string
  default = "index.html"
}

variable bucket_website_error {
  type    = string
  default = "404.html"
}

variable bucket_viewer_access_role {
  type    = string
  default = "roles/storage.objectViewer"
}

variable bucket_sa_access_role {
  type    = string
  default = "roles/storage.admin"
}

variable http_port {
  type    = number
  default = 80
}

variable https_port {
  type    = number
  default = 443
}

variable domains {
  type = list(string)
}

variable credentials_path {
  type = string
}

variable remote_state_bucket {
  type = string
}

variable remote_state_prefix {
  type = string
}

variable cert_prefix {
  type = string
}

variable cert_byte_length {
  type = string
}

variable terraform_cloud_organization {
  type = string
}

variable terraform_cloud_workspace {
  type = string
}
