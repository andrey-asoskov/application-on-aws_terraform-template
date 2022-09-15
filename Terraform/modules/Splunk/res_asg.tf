data "aws_region" "current" {}

data "template_file" "user_data" { # tflint-ignore: terraform_required_providers
  template = file("${path.module}/templates/user-data_splunk.sh")

  vars = {
    REGION = data.aws_region.current.name
    #splunk_admin_password_ciphertext              = var.splunk_admin_password_ciphertext
    splunk_hf_elb_dns              = "splunk-hf-${var.solution_short}-${var.env}-${data.aws_region.current.name}.company-solutions.com"
    splunk_hf_elb_port             = "9997"
    splunk_solution_name           = var.env == "prod" || var.env == "prd" ? format("splunk-%s-con", var.solution_short) : format("splunk-%s-%s", var.solution_short, var.index_name)
    splunk_srv_elb_dns             = var.env == "prod" || var.env == "prd" ? var.shared_splunk_srv_dns["prod"] : var.shared_splunk_srv_dns["npn"]
    splunk_srv_elb_port            = var.shared_splunk_srv_lb_port
    splunk_srv_elb_deployment_port = var.shared_splunk_srv_deployment_port
    target_uri                     = var.env == "prod" || var.env == "prd" ? var.target_uri["prod"] : var.target_uri["npn"]
    index_name                     = var.index_name
    name                           = var.solution_short
    env                            = var.env
    NESSUS_KEY_CIPHERTEXT          = var.nessus_key_ciphertext
    NEWRELIC_KEY_CIPHERTEXT        = var.newrelic_key_ciphertext
  }
}

resource "aws_launch_template" "splunk-launch-template" {
  name                   = "${var.solution}-${var.env}-splunk_launch_template"
  description            = "${var.solution}-${var.env} Splunk Launch Template"
  update_default_version = true
  image_id               = var.asg_splunk_ImageID
  instance_type          = var.asg_splunk_instance_type

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 60
      volume_type = "gp2"
      encrypted   = true
      kms_key_id  = var.kms_alias_arn
    }
  }

  ebs_optimized = true

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.sg_Splunk_Instance_id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.Splunk.name
  }

  monitoring {
    enabled = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  #vpc_security_group_ids = [var.sg_Splunk_Instance_id]

  user_data = base64encode(data.template_file.user_data.rendered)

  tag_specifications {
    resource_type = "instance"

    tags = merge({
      Name    = "${var.solution}-${var.env}-splunk"
      shutOff = var.asg_splunk_shutoff
      Backup  = "false"
    }, local.common_tags)
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge({
      Name     = "${var.solution}-${var.env}-splunk"
      Instance = "${var.solution}-${var.env}-splunk"
    }, local.common_tags)
  }

  tags = merge({
    Name = "${var.solution}-${var.env}-splunk-launch-template"
  }, local.common_tags)
}

resource "aws_autoscaling_group" "splunk-asg" {
  name                      = "${var.solution}-${var.env}-splunk_asg"
  desired_capacity          = var.asg_splunk_DesiredSize
  max_size                  = var.asg_splunk_MaxSize
  min_size                  = var.asg_splunk_MinSize
  default_cooldown          = 60
  health_check_type         = "EC2"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.splunk-launch-template.id
    version = "$Latest"
  }

  vpc_zone_identifier = var.subnets_ids
  target_group_arns   = [aws_lb_target_group.splunk-int-targetgroup.arn]

  tag {
    key                 = "Name"
    value               = "${var.solution}-${var.env}-splunk"
    propagate_at_launch = true
  }
  tag {
    key                 = "Solution"
    value               = var.solution
    propagate_at_launch = true
  }
  tag {
    key                 = "shutOff"
    value               = var.asg_splunk_shutoff
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
}

resource "aws_autoscaling_policy" "ScalingUpPolicy" {
  name                   = "${var.solution}-${var.env}-splunk-ScalingUpPolicy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.splunk-asg.name
}

resource "aws_autoscaling_policy" "ScalingDownPolicy" {
  name                   = "${var.solution}-${var.env}-splunk-ScalingDownPolicy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.splunk-asg.name
}
