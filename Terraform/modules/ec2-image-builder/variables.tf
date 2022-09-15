variable "solution" {
  description = "Name of a solution"
  type        = string
}

variable "solution_short" {
  description = "Short name of a solution"
  type        = string
}

variable "app_version" {
  description = "Version of app Forms"
  type        = string
}

variable "forms_file" {
  description = "Path to TOE file for forms"
  type        = string
}

variable "trainer_file" {
  description = "Path to TOE file for trainer"
  type        = string
}

variable "ansible_s3_uri" {
  description = "S3 URI to Ansible"
  type        = string
}

variable "ec2ib_s3_bucket" {
  description = "EC2 Image builder S3 bucket"
  type        = string
}

variable "base_ami_id" {
  description = "ID of Base AMI to create the image"
  type        = string
}

variable "base_ami_name" {
  description = "Name of Base AMI to create the image"
  type        = string
}

variable "base_ami_creation_date" {
  description = "Creation time of Base AMI to create the image"
  type        = string
}

variable "kms_key_arn" {
  type        = string
  description = "KMS key arn"
}

variable "aws_imagebuilder_infrastructure_configuration_infra_config_arn" {
  type        = string
  description = "aws_imagebuilder_infrastructure_configuration.infra_config.arn"
}
