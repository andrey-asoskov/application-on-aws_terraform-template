data "aws_ami" "CNG_ami" {
  executable_users = ["self"]
  most_recent      = true
  owners           = ["409661236178"]

  filter {
    name   = "name"
    values = ["CNG-CAP-Ubuntu20_04-CT-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_imagebuilder_infrastructure_configuration" "infra_config" {
  description                   = "${var.solution_short} EC2 Image Builder Infra Config"
  instance_profile_name         = aws_iam_instance_profile.image_builder_role.name
  instance_types                = ["c6i.4xlarge"]
  name                          = "${var.solution_short}_infra_config"
  security_group_ids            = [data.terraform_remote_state.VPC.outputs.sg_App_Forms_id]
  subnet_id                     = data.terraform_remote_state.VPC.outputs.subnets_private_ids[0]
  terminate_instance_on_failure = true

  logging {
    s3_logs {
      s3_bucket_name = data.terraform_remote_state.VPC.outputs.s3_access-logs_bucket_id
      s3_key_prefix  = "ec2-image-builder-logs"
    }
  }

  tags = {
    Name = "${var.solution_short}_infra_config"
  }
}


module "ec2-image-builder_32_0_17" {
  source = "../../modules/ec2-image-builder"

  solution                                                       = var.solution
  solution_short                                                 = var.solution_short
  forms_file                                                     = "${path.cwd}/AWSTOE_templates/forms.yaml"
  trainer_file                                                   = "${path.cwd}/AWSTOE_templates/trainer.yaml"
  ansible_s3_uri                                                 = "s3://${aws_s3_object.ansible.bucket}/${aws_s3_object.ansible.key}"
  ec2ib_s3_bucket                                                = aws_s3_bucket.ec2ib_bucket.id
  base_ami_id                                                    = data.aws_ami.CNG_ami.id
  base_ami_name                                                  = data.aws_ami.CNG_ami.name
  base_ami_creation_date                                         = data.aws_ami.CNG_ami.creation_date
  kms_key_arn                                                    = data.terraform_remote_state.VPC.outputs.kms_key_arn
  aws_imagebuilder_infrastructure_configuration_infra_config_arn = aws_imagebuilder_infrastructure_configuration.infra_config.arn

  app_version = "32.0.17"
}

module "ec2-image-builder_32_0_20" {
  source = "../../modules/ec2-image-builder"

  solution                                                       = var.solution
  solution_short                                                 = var.solution_short
  forms_file                                                     = "${path.cwd}/AWSTOE_templates/forms.yaml"
  trainer_file                                                   = "${path.cwd}/AWSTOE_templates/trainer.yaml"
  ansible_s3_uri                                                 = "s3://${aws_s3_object.ansible.bucket}/${aws_s3_object.ansible.key}"
  ec2ib_s3_bucket                                                = aws_s3_bucket.ec2ib_bucket.id
  base_ami_id                                                    = data.aws_ami.CNG_ami.id
  base_ami_name                                                  = data.aws_ami.CNG_ami.name
  base_ami_creation_date                                         = data.aws_ami.CNG_ami.creation_date
  kms_key_arn                                                    = data.terraform_remote_state.VPC.outputs.kms_key_arn
  aws_imagebuilder_infrastructure_configuration_infra_config_arn = aws_imagebuilder_infrastructure_configuration.infra_config.arn

  app_version = "32.0.20"
}
