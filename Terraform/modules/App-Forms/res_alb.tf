// External

resource "aws_lb" "app-ext-alb" { #tfsec:ignore:aws-elb-alb-not-public
  name                       = "${var.solution_short}-${var.env}-app-ext-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.sg_App_Forms_ALB_id]
  subnets                    = var.subnets_public_ids
  idle_timeout               = 1800
  enable_deletion_protection = false
  drop_invalid_header_fields = true

  access_logs {
    bucket  = lookup(var.aws-elb-access-logs_bucket, var.env)
    enabled = true
  }

  tags = {
    Name = "${var.solution_short}-${var.env}-app-ext-alb"
  }
}

resource "aws_lb_listener" "external-https-listener" {
  load_balancer_arn = aws_lb.app-ext-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  #ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  ssl_policy      = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  certificate_arn = aws_acm_certificate.alb.arn

  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.app-ext-targetgroup.arn
      }
      stickiness {
        duration = 1
        enabled  = false
      }
    }
  }

  depends_on = [
    aws_acm_certificate_validation.alb
  ]
}

resource "aws_wafv2_web_acl_association" "app-ext-alb" {
  resource_arn = aws_lb.app-ext-alb.arn
  web_acl_arn  = var.wafv2_web_acl_alb_arn
}

// Internal

resource "aws_lb" "app-int-alb" {
  name                       = "${var.solution_short}-${var.env}-app-int-alb"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [var.sg_App_Forms_ALB_id]
  subnets                    = var.subnets_public_ids
  idle_timeout               = 60
  enable_deletion_protection = false
  drop_invalid_header_fields = true

  access_logs {
    bucket  = lookup(var.aws-elb-access-logs_bucket, var.env)
    enabled = true
  }

  tags = {
    Name = "${var.solution_short}-${var.env}-app-int-alb"
  }
}

resource "aws_lb_listener" "internal-https-listener" {
  load_balancer_arn = aws_lb.app-int-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  certificate_arn   = aws_acm_certificate.alb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-int-targetgroup.arn
  }

  depends_on = [
    aws_acm_certificate_validation.alb
  ]
}

resource "aws_lb_target_group" "app-ext-targetgroup" {
  name                 = "${var.solution_short}-${var.env}-app-ext"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 20

  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 3600
  }

  health_check {
    enabled             = true
    interval            = (var.env != "dev" ? 5 : 300)
    path                = "/login"
    port                = 80
    protocol            = "HTTP"
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.solution_short}-${var.env}-app-ext-targetgroup"
  }
}

resource "aws_lb_target_group" "app-int-targetgroup" {
  name                 = "${var.solution_short}-${var.env}-app-int"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 20

  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 3600
  }

  health_check {
    enabled             = true
    interval            = 5
    path                = "/login"
    port                = 80
    protocol            = "HTTP"
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.solution_short}-${var.env}-app-int-targetgroup"
  }
}
