provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  backend "s3" {
    region  = "ap-northeast-1"
    encrypt = true
    key     = "tfdemo/global/cert"
  }
}

module "cert" {
  source     = "github.com/hkakehashi/tfdemo-modules//cert?ref=v1.1.1"
  domains    = ["tfdemo-prod.hkakehas.tokyo", "tfdemo-stage.hkakehas.tokyo"]
  dns_zone   = "hkakehas.tokyo"
  tls_config = "HTTP/3 & TLS v1.3"
}

output "domains" {
  value = module.cert.cert_info.domains
}