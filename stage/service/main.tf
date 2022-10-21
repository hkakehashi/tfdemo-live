terraform {
  backend "s3" {
    region  = "ap-northeast-1"
    encrypt = true
    key     = "tfdemo/stage/service"
  }
}

module "service" {
  source          = "github.com/hkakehashi/tfdemo-modules//service?ref=v1.1.1"
  domain          = "tfdemo-stage.hrmsk66.com"
  papertrail_addr = "logs.papertrailapp.com"
  papertrail_port = 37952
}

output "domain" {
  value = module.service.service_info.domain
}
