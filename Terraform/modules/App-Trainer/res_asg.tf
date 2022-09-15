data "aws_region" "current" {}

resource "aws_launch_template" "app-trainer-launch-template" {
  name                   = "${var.solution_short}-${var.env}-app_trainer_launch_template"
  description            = "${var.solution_short}-${var.env} App Trainer Launch Template"
  update_default_version = true
  image_id               = var.asg_app_trainer_ImageName
  instance_type          = var.asg_app_trainer_instance_types[0]

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 100
      volume_type = "gp2"
      encrypted   = true
      kms_key_id  = var.kms_alias_arn
    }
  }

  block_device_mappings {
    device_name = "/dev/xvdb"

    ebs {
      volume_size = 40
      volume_type = "gp2"
      encrypted   = true
      kms_key_id  = var.kms_alias_arn
    }
  }

  ebs_optimized = true

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.sg_App_Trainer_id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.AppTrainer.name
  }

  monitoring {
    enabled = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  #vpc_security_group_ids = [var.sg_App_Trainer_id]

  user_data = base64encode(local.userdata)

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name         = "${var.solution_short}-${var.env}-app-trainer"
      shutOff      = var.asg_app_trainer_shutoff
      Backup       = var.asg_app_trainer_backup
      component    = "forms"
      Solution     = var.solution
      Environment  = var.env
      ManagedByTFE = 1
      used_for     = var.aws_account_type == "prod" ? "prod" : "non_prod"
      product_id   = var.product_id
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name         = "${var.solution_short}-${var.env}-app-trainer"
      Backup       = var.asg_app_trainer_backup
      component    = "forms"
      Solution     = var.solution
      Environment  = var.env
      ManagedByTFE = 1
      used_for     = var.aws_account_type == "prod" ? "prod" : "non_prod"
      product_id   = var.product_id
    }
  }

  tags = {
    Name = "${var.solution_short}-${var.env}-app-trainer-launch-template"
  }
}

resource "aws_autoscaling_group" "app-trainer-asg" {
  name                      = "${var.solution_short}-${var.env}-app_trainer_asg"
  desired_capacity          = var.asg_app_trainer_DesiredSize
  max_size                  = var.asg_app_trainer_MaxSize
  min_size                  = var.asg_app_trainer_MinSize
  default_cooldown          = 60
  health_check_type         = "EC2"
  health_check_grace_period = 120

  /*   launch_template {
    id      = aws_launch_template.app-trainer-launch-template.id
    version = "$Latest"
  } */

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.app-trainer-launch-template.id
        version            = "$Latest"
      }

      dynamic "override" {
        for_each = var.asg_app_trainer_instance_types
        content {
          instance_type     = override.value
          weighted_capacity = "1"
        }
      }
    }
  }

  vpc_zone_identifier = var.subnets_ids

  tag {
    key                 = "Name"
    value               = "${var.solution_short}-${var.env}-app-trainer"
    propagate_at_launch = true
  }
  tag {
    key                 = "shutOff"
    value               = var.asg_app_trainer_shutoff
    propagate_at_launch = true
  }
  tag {
    key                 = "backup"
    value               = var.asg_app_trainer_backup
    propagate_at_launch = true
  }
  tag {
    key                 = "component"
    value               = "trainer"
    propagate_at_launch = true
  }
  tag {
    key                 = "Solution"
    value               = var.solution
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = var.env
    propagate_at_launch = true
  }
  tag {
    key                 = "ManagedByTFE"
    value               = 1
    propagate_at_launch = true
  }
  tag {
    key                 = "used_for"
    value               = var.aws_account_type == "prod" ? "prod" : "non_prod"
    propagate_at_launch = true
  }
  tag {
    key                 = "product_id"
    value               = var.product_id
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "ScalingUpPolicy" {
  name                   = "${var.solution_short}-${var.env}-app_trainer_ScalingUpPolicy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.app-trainer-asg.name
}

resource "aws_autoscaling_policy" "ScalingDownPolicy" {
  name                   = "${var.solution_short}-${var.env}-app_trainer_ScalingDownPolicy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.app-trainer-asg.name
}
