// S3
data "archive_file" "newrelic-ips-update_py" {
  type        = "zip"
  source_dir  = "${path.module}/Lambdas/newrelic-ips-update/python_packages"
  output_path = "${path.module}/Lambdas/newrelic-ips-update.zip"
}

resource "aws_s3_object" "newrelic-ips-update_zip" {
  bucket      = aws_s3_bucket.code_bucket.id
  key         = "Lambdas/newrelic-ips-update.zip"
  source      = data.archive_file.newrelic-ips-update_py.output_path
  source_hash = data.archive_file.newrelic-ips-update_py.output_base64sha256

  tags = {
    Name = "${var.solution_short}-newrelic-ips-update.zip"
  }
}

//IAM
data "aws_iam_policy_document" "newrelic-ips-update_lambda" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "newrelic-ips-update_lambda" {
  name               = "${var.solution_short}-newrelic-ips-update_lambda"
  assume_role_policy = data.aws_iam_policy_document.newrelic-ips-update_lambda.json

  tags = {
    Name = "${var.solution_short}-newrelic-ips-update_lambda"
  }
}

data "aws_iam_policy_document" "newrelic-ips-update_lambda_permissions" {
  #checkov:skip=CKV_AWS_111:Ensure IAM policies does not allow write access without constraints

  statement {
    sid    = "waf1"
    effect = "Allow"
    actions = [
      "wafv2:ListIPSets"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "waf2"
    effect = "Allow"
    actions = [
      "wafv2:UpdateIPSet"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "newrelic-ips-update_lambda_permissions" {
  name        = "${var.solution_short}-newrelic-ips-update_lambda_permissions"
  path        = "/${var.solution_short}/"
  description = "Permission Policy for Lambdas (newrelic-ips-update) - ${var.solution}"
  policy      = data.aws_iam_policy_document.newrelic-ips-update_lambda_permissions.json

  tags = {
    Name = "${var.solution_short}-newrelic-ips-update_lambda_permissions"
  }
}

resource "aws_iam_role_policy_attachment" "newrelic-ips-update_lambda1" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.newrelic-ips-update_lambda.name
}

resource "aws_iam_role_policy_attachment" "newrelic-ips-update_lambda2" {
  policy_arn = aws_iam_policy.newrelic-ips-update_lambda_permissions.arn
  role       = aws_iam_role.newrelic-ips-update_lambda.name
}

// Lambda
resource "aws_lambda_function" "newrelic-ips-update" {
  function_name                  = "${var.solution_short}-newrelic-ips-update"
  s3_bucket                      = aws_s3_object.newrelic-ips-update_zip.bucket
  s3_key                         = aws_s3_object.newrelic-ips-update_zip.key
  source_code_hash               = data.archive_file.newrelic-ips-update_py.output_base64sha256
  role                           = aws_iam_role.newrelic-ips-update_lambda.arn
  handler                        = "newrelic-ips-update.handler"
  architectures                  = ["x86_64"]
  runtime                        = "python3.9"
  memory_size                    = "128"
  timeout                        = "180"
  reserved_concurrent_executions = "-1"
  environment {
    variables = {
      waf_ip_set_name  = aws_wafv2_ip_set.NR-Synthetic-monitoring-IP-ranges.name
      waf_ip_set_scope = "CLOUDFRONT"
    }
  }

  tags = {
    Name = "${var.solution_short}-newrelic-ips-update"
  }

  depends_on = [
    aws_iam_role_policy_attachment.newrelic-ips-update_lambda1,
    aws_cloudwatch_log_group.newrelic-ips-update
  ]
}

resource "aws_lambda_permission" "newrelic-ips-update" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.newrelic-ips-update.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.newrelic-ips-update.arn
}


resource "aws_cloudwatch_event_rule" "newrelic-ips-update" {
  name                = "newrelic-ips-update"
  description         = "Update New Relic IPs"
  schedule_expression = "cron(0 10 * * ? *)" #UTC
  #schedule_expression = "cron(20 12 * * ? *)" #UTC #For tests

  tags = {
    Name = "${var.solution_short}-newrelic-ips-update"
  }
}

resource "aws_cloudwatch_event_target" "newrelic-ips-update" {
  rule = aws_cloudwatch_event_rule.newrelic-ips-update.name
  arn  = aws_lambda_function.newrelic-ips-update.arn
}

// CloudWatch
resource "aws_cloudwatch_log_group" "newrelic-ips-update" {
  #checkov:skip=CKV_AWS_158:Ensure that CloudWatch Log Group is encrypted by KMS
  name              = "/aws/lambda/${var.solution_short}-newrelic-ips-update"
  retention_in_days = 14
  #kms_key_id        = aws_kms_alias.global-key-alias.id

  tags = {
    Name = "${var.solution_short}-/aws/lambda/newrelic-ips-update"
  }
}
