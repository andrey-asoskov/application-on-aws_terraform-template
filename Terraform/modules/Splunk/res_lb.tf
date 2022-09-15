resource "aws_lb" "splunk-int-lb" {
  name                             = "${var.solution_short}-${var.env}-splunk-int-lb"
  internal                         = true
  load_balancer_type               = "network"
  subnets                          = var.subnets_ids
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true

  access_logs {
    bucket  = "aws-elb-access-logs-468409605596-us-east-1"
    enabled = true
  }

  tags = merge({
    Name = "${var.solution_short}-${var.env}-splunk-int-lb"
  }, local.common_tags)
}

resource "aws_lb_listener" "internal-listener" {
  load_balancer_arn = aws_lb.splunk-int-lb.arn
  port              = "9997"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.splunk-int-targetgroup.arn
  }
}

resource "aws_lb_target_group" "splunk-int-targetgroup" {
  name                 = "${var.solution_short}-${var.env}-splunk-int"
  port                 = 9997
  protocol             = "TCP"
  vpc_id               = var.vpc_id
  deregistration_delay = 20

  health_check {
    enabled             = true
    interval            = 10
    port                = 9997
    protocol            = "TCP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge({
    Name = "${var.solution_short}-${var.env}-splunk-int-targetgroup"
  }, local.common_tags)
}
