resource "aws_sns_topic_subscription" "secops-golden-ami" {
  topic_arn = "arn:aws:sns:us-east-1:933806036560:secops-golden-ami-announcements"
  protocol  = "email"
  endpoint  = "Andrey_asoskov@external.company.com"
}
