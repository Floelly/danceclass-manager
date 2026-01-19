# URL Map
resource "google_compute_url_map" "frontend" {
  name            = "frontend-and-backend-url-map"
  default_service = google_compute_backend_bucket.frontend.id
}

# Self-signed Cert
resource "tls_private_key" "frontend" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "frontend" {
  private_key_pem = tls_private_key.frontend.private_key_pem

  validity_period_hours = 72
  early_renewal_hours   = 24

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  dns_names = [] # real DNS name for production recommended!

  subject {
    common_name  = "dance-class-manager"
    organization = "Dance Class Manager Team"
  }
}

resource "google_compute_ssl_certificate" "self_signed_frontend" {
  name_prefix = "self-signed-frontend-cert"
  private_key = tls_private_key.frontend.private_key_pem
  certificate = tls_self_signed_cert.frontend.cert_pem
}


# HTTPS Proxy (Real certificate for production recommended!)
resource "google_compute_target_https_proxy" "frontend" {
  name             = "frontend-and-backend-https-proxy"
  url_map          = google_compute_url_map.frontend.id
  ssl_certificates = [google_compute_ssl_certificate.self_signed_frontend.self_link]
}

# Forwarding Rule
resource "google_compute_global_forwarding_rule" "frontend" {
  name                  = "frontend-https-lb"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_protocol           = "TCP"
  port_range            = "443"
  ip_address            = google_compute_global_address.frontend_ip.id
  target                = google_compute_target_https_proxy.frontend.id
}