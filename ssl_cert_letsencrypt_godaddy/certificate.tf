variable "account_email" { }
variable "account_key_file" {} 
variable "domain" { }
variable "godaddy_key" { }
variable "godaddy_secret" { }
variable "cert_dir" { }
variable "cert_prefix" { }
variable "production" {
  default = "false"
}

provider "acme" {
  server_url = "https://acme-${var.production == "true" ? "v02" : "staging-v02"}.api.letsencrypt.org/directory"
}

data "local_file" "account_key" {
    filename = "${var.account_key_file}"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = "${data.local_file.account_key.content != "" ? data.local_file.account_key.content : tls_private_key.private_key.private_key_pem}"
  email_address   = "${var.account_email}"
}

resource "acme_certificate" "certificate" {
  account_key_pem           = "${acme_registration.reg.account_key_pem}"
  common_name               = "${var.domain}"

  dns_challenge {
    provider = "godaddy"
    config {
      GODADDY_API_KEY     = "${var.godaddy_key}"
      GODADDY_API_SECRET  = "${var.godaddy_secret}"
    }
  }

}

resource "local_file" "cert_file" {
    filename = "${var.cert_dir}/${var.cert_prefix}.crt"
    content = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}"
}

resource "local_file" "key_file" {
    filename = "${var.cert_dir}/${var.cert_prefix}.key"
    content = "${acme_certificate.certificate.private_key_pem}"
}

output "account_id" {
  value = "${acme_registration.reg.id}"
}

resource "local_file" "account_key_file" {
    filename = "${var.account_key_file}"
    content = "${data.local_file.account_key.content != "" ? data.local_file.account_key.content : tls_private_key.private_key.private_key_pem}"
}