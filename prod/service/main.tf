terraform {
  backend "s3" {
    region  = "ap-northeast-1"
    encrypt = true
    key     = "tfdemo/prod/service"
  }
}

module "service" {
  source          = "github.com/hkakehashi/tfdemo-modules//service?ref=v1.0.4"
  domain          = "tfdemo-prod.hrmsk66.com"
  papertrail_addr = "logs.papertrailapp.com"
  papertrail_port = 37952
}

output "domain" {
  value = module.service.service_info.domain
}