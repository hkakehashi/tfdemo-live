terraform {
  backend "s3" {
    region  = "ap-northeast-1"
    encrypt = true
    key     = "tfdemo/service/stage"
  }
}

module "service" {
  source     = "github.com/hkakehashi/tfdemo-modules//service?ref=v1.0.3"
  domain          = "tfdemo-stage.hkakehas.tokyo"
}

output "domain" {
  value = module.service.service_info.domain
}