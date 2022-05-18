terraform {
  backend "s3" {
    region  = "ap-northeast-1"
    encrypt = true
    key     = "tfdemo/stage/service"
  }
}

module "service" {
  source          = "github.com/hkakehashi/tfdemo-modules//service?ref=v1.3.0"
  domain          = "tfdemo-stage.hkakehas.tokyo"
  papertrail_addr = "xxx.papertrailapp.com"
  papertrail_port = 12345
}

output "domain" {
  value = module.service.service_info.domain
}
