module "cert" {
  source     = "github.com/hkakehashi/tfdemo-modules//cert?ref=v1.0.3"
  domains    = var.domains
  dns_zone   = var.dns_zone
  tls_config = var.tls_config
}