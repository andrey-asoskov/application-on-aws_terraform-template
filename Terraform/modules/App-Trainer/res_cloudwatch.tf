resource "aws_cloudwatch_metric_alarm" "App-Trainer-CPUHighAlarm" {
  alarm_name          = "${var.solution_short}-${var.env}-App-Trainer-CPUHighAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app-trainer-asg.name
  }

  alarm_description = "Alarm if CPU load is high"
  alarm_actions     = [aws_autoscaling_policy.ScalingUpPolicy.arn]

  tags = {
    Name = "${var.solution_short}-${var.env}-App-Core-CPUHighAlarm"
  }
}

resource "aws_cloudwatch_metric_alarm" "App-Trainer-CPULowAlarm" {
  alarm_name          = "${var.solution_short}-${var.env}-App-Trainer-CPULowAlarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app-trainer-asg.name
  }

  alarm_description = "Alarm if CPU load is low"
  alarm_actions     = [aws_autoscaling_policy.ScalingDownPolicy.arn]

  tags = {
    Name = "${var.solution_short}-${var.env}-App-Core-CPULowAlarm"
  }
}
