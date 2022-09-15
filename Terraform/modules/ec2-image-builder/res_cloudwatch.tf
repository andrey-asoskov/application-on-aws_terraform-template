resource "aws_cloudwatch_log_group" "forms" {
  name              = "/aws/imagebuilder/${var.solution_short}-forms-${local.app_version2}-${random_uuid.randomizer.result}"
  kms_key_id        = var.kms_key_arn
  retention_in_days = 90

  tags = {
    Name = "${var.solution_short}-forms-${local.app_version2}"
  }
}

resource "aws_cloudwatch_log_group" "trainer" {
  name              = "/aws/imagebuilder/${var.solution_short}-trainer-${local.app_version2}-${random_uuid.randomizer.result}"
  kms_key_id        = var.kms_key_arn
  retention_in_days = 90

  tags = {
    Name = "${var.solution_short}-trainer-${local.app_version2}"
  }
}
