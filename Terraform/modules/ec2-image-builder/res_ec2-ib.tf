data "aws_region" "current" {}

resource "random_uuid" "randomizer" {
  keepers = {
    "ami_id"    = var.base_ami_name
    "forms"     = local.AWSTOE_forms
    "trainer"   = local.AWSTOE_trainer
    "timestamp" = timestamp()
  }
}

//Forms
resource "aws_imagebuilder_component" "forms" {
  name     = "${var.solution_short}-forms-${local.app_version2}-${random_uuid.randomizer.result}"
  platform = "Linux"
  uri      = "s3://${aws_s3_object.forms.bucket}/${aws_s3_object.forms.key}"
  version  = var.app_version

  tags = {
    Name = "${var.solution_short}-forms-${local.app_version2}"
  }
}

resource "aws_imagebuilder_image_recipe" "forms" {
  name         = "${var.solution_short}-forms-${local.app_version2}-${random_uuid.randomizer.result}"
  parent_image = var.base_ami_id
  #version      = "0.0.1"
  version = var.app_version

  block_device_mapping {
    device_name = "/dev/sda1"

    ebs {
      delete_on_termination = true
      volume_size           = 60
      volume_type           = "gp2"
      encrypted             = true
      kms_key_id            = var.kms_key_arn
    }
  }

  block_device_mapping {
    device_name = "/dev/xvdb"

    ebs {
      delete_on_termination = true
      volume_size           = 40
      volume_type           = "gp2"
      encrypted             = true
      kms_key_id            = var.kms_key_arn
    }
  }

  /*  component {
    component_arn = "arn:aws:imagebuilder:us-east-1:aws:component/apt-repository-test-linux/1.0.0"
  }
*/
  component {
    component_arn = "arn:aws:imagebuilder:us-east-1:aws:component/aws-cli-version-2-linux/1.0.0"
  }

  component {
    component_arn = aws_imagebuilder_component.forms.arn
  }

  tags = {
    Name = "${var.solution_short}-forms-${local.app_version2}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_imagebuilder_distribution_configuration" "forms" {
  name = "${var.solution_short}-forms-${local.app_version2}"

  distribution {
    ami_distribution_configuration {
      ami_tags = {
        Name     = "${var.solution_short}-forms-${var.app_version}-{{imagebuilder:buildDate}}"
        Solution = var.solution
        Version  = var.app_version
        #Comment                 = var.app_comment
        OS_Version            = "Ubuntu 20"
        Base_AMI_id           = var.base_ami_id
        Base_AMI_Name         = var.base_ami_name
        Base_AMI_CreationDate = var.base_ami_creation_date
        BuildDate             = "{{imagebuilder:buildDate}}"
        BuildVersion          = "{{imagebuilder:buildVersion}}"
        ManagedByTFE          = 1
      }

      name = "${var.solution_short}-forms-${local.app_version2}-{{imagebuilder:buildDate}}" # A bug: doesn't support dots
    }

    region = data.aws_region.current.name
  }

  tags = {
    Name = "${var.solution_short}-forms-${local.app_version2}"
  }
}

resource "aws_imagebuilder_image_pipeline" "forms" {
  name                             = "${var.solution_short}-forms-${local.app_version2}"
  image_recipe_arn                 = aws_imagebuilder_image_recipe.forms.arn
  infrastructure_configuration_arn = var.aws_imagebuilder_infrastructure_configuration_infra_config_arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.forms.arn

  schedule {
    schedule_expression = "cron(1 0 ? * wed *)"
  }

  tags = {
    Name = "${var.solution_short}-forms-${local.app_version2}"
  }

  depends_on = [
    aws_cloudwatch_log_group.forms
  ]
}


// Trainer
resource "aws_imagebuilder_component" "trainer" {
  name     = "${var.solution_short}-trainer-${local.app_version2}-${random_uuid.randomizer.result}"
  platform = "Linux"
  uri      = "s3://${aws_s3_object.trainer.bucket}/${aws_s3_object.trainer.key}"
  version  = var.app_version

  tags = {
    Name = "${var.solution_short}-trainer-${local.app_version2}"
  }
}

resource "aws_imagebuilder_image_recipe" "trainer" {
  name         = "${var.solution_short}-trainer-${local.app_version2}-${random_uuid.randomizer.result}"
  parent_image = var.base_ami_id
  #version      = "0.0.1"
  version = var.app_version

  block_device_mapping {
    device_name = "/dev/sda1"

    ebs {
      delete_on_termination = true
      volume_size           = 100
      volume_type           = "gp2"
      encrypted             = true
      kms_key_id            = var.kms_key_arn
    }
  }

  block_device_mapping {
    device_name = "/dev/xvdb"

    ebs {
      delete_on_termination = true
      volume_size           = 40
      volume_type           = "gp2"
      encrypted             = true
      kms_key_id            = var.kms_key_arn
    }
  }

  /*  component {
    component_arn = "arn:aws:imagebuilder:us-east-1:aws:component/apt-repository-test-linux/1.0.0"
  }
*/
  component {
    component_arn = "arn:aws:imagebuilder:us-east-1:aws:component/aws-cli-version-2-linux/1.0.0"
  }

  component {
    component_arn = aws_imagebuilder_component.trainer.arn
  }

  tags = {
    Name = "${var.solution_short}-trainer-${local.app_version2}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_imagebuilder_distribution_configuration" "trainer" {
  name = "${var.solution_short}-trainer-${local.app_version2}"

  distribution {
    ami_distribution_configuration {
      ami_tags = {
        Name     = "${var.solution_short}-trainer-${var.app_version}-{{imagebuilder:buildDate}}"
        Solution = var.solution
        Version  = var.app_version
        #Comment                 = var.app_comment
        OS_Version            = "Ubuntu 20"
        Base_AMI_id           = var.base_ami_id
        Base_AMI_Name         = var.base_ami_name
        Base_AMI_CreationDate = var.base_ami_creation_date
        BuildDate             = "{{imagebuilder:buildDate}}"
        BuildVersion          = "{{imagebuilder:buildVersion}}"
        ManagedByTFE          = 1
      }

      name = "${var.solution_short}-trainer-${local.app_version2}-{{imagebuilder:buildDate}}" # A bug: doesn't support dots

      #   launch_permission {
      #     user_ids = ["123456789012"]
      #   }
    }

    region = data.aws_region.current.name
  }

  tags = {
    Name = "${var.solution_short}-trainer-${local.app_version2}"
  }
}

resource "aws_imagebuilder_image_pipeline" "trainer" {
  name                             = "${var.solution_short}-trainer-${local.app_version2}"
  image_recipe_arn                 = aws_imagebuilder_image_recipe.trainer.arn
  infrastructure_configuration_arn = var.aws_imagebuilder_infrastructure_configuration_infra_config_arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.trainer.arn

  schedule {
    schedule_expression = "cron(1 0 ? * wed *)"
  }

  tags = {
    Name = "${var.solution_short}-trainer-${local.app_version2}"
  }

  depends_on = [
    aws_cloudwatch_log_group.trainer
  ]
}
