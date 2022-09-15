resource "aws_cloudwatch_log_group" "db" {
  name              = "/aws/rds/instance/${var.solution}-${var.env}-db-instance/postgresql"
  kms_key_id        = var.kms_alias_arn
  retention_in_days = 90

  tags = {
    Name = "${var.solution}-db"
  }
}
