locals {
  app_version2 = replace(var.app_version, ".", "_")
  AWSTOE_forms = templatefile(var.forms_file, {
    APP_VERSION = var.app_version
    ANSIBLE_S3  = var.ansible_s3_uri
    AWS_REGION  = data.aws_region.current.name
    }
  )
  AWSTOE_trainer = templatefile(var.trainer_file, {
    APP_VERSION = var.app_version
    ANSIBLE_S3  = var.ansible_s3_uri
    AWS_REGION  = data.aws_region.current.name
    }
  )
}
